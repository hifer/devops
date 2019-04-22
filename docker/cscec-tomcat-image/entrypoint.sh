#!/bin/bash

#### set spring env ###
set_spring_env(){
  config_url=`java -jar /usr/local/share/printenv.jar spring.cloud.config.uri`
  config_name=`java -jar /usr/local/share/printenv.jar spring.cloud.config.name`
  config_profile=`java -jar /usr/local/share/printenv.jar spring.cloud.config.profile`
  final_url=$config_url/$config_name-$config_profile.properties
  war_name=`ls /usr/local/tomcat/webapps/`
  curl $final_url -o /usr/local/tomcat/webapps/$war_name/WEB-INF/classes/application.properties
  sed -ri 's/:[ ]/=/g' /usr/local/tomcat/webapps/$war_name/WEB-INF/classes/application.properties
}

#### APM ####
set_apm(){
	if [[ "${PINPOINT_ENABLED}" != "" && "$(echo $PINPOINT_ENABLED | tr [a-z] [A-Z])" == "TRUE" && "$CONTEXT_NAME" != "" ]]; then
        PINPOINT_COLLECTOR_IP=${PINPOINT_COLLECTOR_IP:-127.0.0.1}
		CATALINA_OPTS="$CATALINA_OPTS -javaagent:${CATALINA_HOME}/pinpoint-agent-1.7.2/pinpoint-bootstrap-1.7.2.jar"
		CATALINA_OPTS="$CATALINA_OPTS -Dpinpoint.agentId=${HOSTNAME:0:24}"
		CATALINA_OPTS="$CATALINA_OPTS -Dpinpoint.applicationName=${CONTEXT_NAME}"
		CATALINA_STARTUP_FILE="${CATALINA_HOME}/bin/catalina.sh"
		grep '^CATALINA_OPTS=' ${CATALINA_STARTUP_FILE} || sed -i -e "/cygwin=false/i CATALINA_OPTS=\"\$CATALINA_OPTS ${CATALINA_OPTS}\"" ${CATALINA_STARTUP_FILE}
		grep '^CATALINA_OPTS=' ${CATALINA_STARTUP_FILE}

		PINPOINT_CONFIG_FILE="${CATALINA_HOME}/pinpoint-agent-1.7.2/pinpoint.config"

		sed -i -e "s/profiler.collector.ip=127.0.0.1/profiler.collector.ip=${PINPOINT_COLLECTOR_IP}/" ${PINPOINT_CONFIG_FILE}
		grep '^profiler.collector.ip=' ${PINPOINT_CONFIG_FILE}
		
		PROFILER_SAMPLING_RATE=${PROFILER_SAMPLING_RATE:-1}
		sed -i -e "s/profiler.sampling.rate=20/profiler.sampling.rate=${PROFILER_SAMPLING_RATE}/" ${PINPOINT_CONFIG_FILE}

		# Adjust pointpoint port.
		COLLECTOR_TCP_PORT=${PINPOINT_COLLECTOR_TCP_PORT:-9994}
		let COLLECTOR_STAT_PORT=${COLLECTOR_TCP_PORT}+1
		let COLLECTOR_SPAN_PORT=${COLLECTOR_TCP_PORT}+2

		sed -i -e "s/profiler.collector.tcp.port=.*/profiler.collector.tcp.port=${COLLECTOR_TCP_PORT}/" ${PINPOINT_CONFIG_FILE}
		grep 'profiler.collector.tcp.port=' ${PINPOINT_CONFIG_FILE}

		sed -i -e "s/profiler.collector.stat.port=.*/profiler.collector.stat.port=${COLLECTOR_STAT_PORT}/" ${PINPOINT_CONFIG_FILE}
		grep 'profiler.collector.stat.port=' ${PINPOINT_CONFIG_FILE}

		sed -i -e "s/profiler.collector.span.port=.*/profiler.collector.span.port=${COLLECTOR_SPAN_PORT}/" ${PINPOINT_CONFIG_FILE}
		grep 'profiler.collector.span.port=' ${PINPOINT_CONFIG_FILE}

		# Configure log level for log4j
		PINPOINT_LOG_CONFIG_FILE="${CATALINA_HOME}/pinpoint-agent-1.7.2/lib/log4j.xml"
		PINPOINT_LOG_LEVEL=${PINPOINT_LOG_LEVEL:-ERROR}
		sed -i -e "s/DEBUG/${PINPOINT_LOG_LEVEL}/g" ${PINPOINT_LOG_CONFIG_FILE}
	fi
}
#### confcenter ####
confcenter(){
	cffile="$CATALINA_HOME/confdownload/conf/disconf.properties"

	[[ -z $cf_disconf_conf_server_host ]] && echo "not found cf_disconf_conf_server_host" || sed -i 's#%cf_disconf_conf_server_host%#'$cf_disconf_conf_server_host'#g' $cffile
	[[ -z $cf_disconf_version ]] && echo "not found cf_disconf_version" || sed -i 's#%cf_disconf_version%#'$cf_disconf_version'#g' $cffile
	[[ -z $cf_disconf_app ]] && echo "not found cf_disconf_app" || sed -i 's#%cf_disconf_app%#'$cf_disconf_app'#g' $cffile
	[[ -z $cf_disconf_env ]] && echo "not found cf_disconf_env" || sed -i 's#%cf_disconf_env%#'$cf_disconf_env'#g' $cffile
	[[ -z $cf_disconf_user_define_download_dir ]] && echo "not found cf_disconf_user_define_download_dir" || sed -i 's#%cf_disconf_user_define_download_dir%#'$cf_disconf_user_define_download_dir'#g' $cffile
	[[ -z $cf_disconf_user_define_confing_file ]] && echo "not found cf_disconf_user_define_confing_file" || sed -i 's#%cf_disconf_user_define_confing_file%#'$cf_disconf_user_define_confing_file'#g' $cffile
	[[ -z $cf_clientAccessKey ]] && echo "not found cf_clientAccessKey" || sed -i 's#%cf_clientAccessKey%#'$cf_clientAccessKey'#g' $cffile
	[[ -z $cf_clientAccessSecret ]] && echo "not found cf_clientAccessSecret" || sed -i 's#%cf_clientAccessSecret%#'$cf_clientAccessSecret'#g' $cffile

	result=`$CATALINA_HOME/confdownload/confcenterdownload`
	echo $result
}

#### JVM ####
limit_jvm(){
	limit_in_bytes=$(cat /sys/fs/cgroup/memory/memory.limit_in_bytes)
	# If not default limit_in_bytes in cgroup
	if [ "$limit_in_bytes" -ne "9223372036854771712" ]
	then
	    limit_in_megabytes=$(expr $limit_in_bytes \/ 1048576)
	    heap_size=$(expr $limit_in_megabytes - $RESERVED_MEGABYTES)
	    export JAVA_OPTS="-Xmx${heap_size}m $JAVA_OPTS"
	    echo JAVA_OPTS=$JAVA_OPTS
	fi
}
#### RUN ####
set_spring_env
set_apm
confcenter
limit_jvm
exec catalina.sh run
