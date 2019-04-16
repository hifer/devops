# pinpoint agent by lvhfa@yonyou.com

JAVA_OPTS=${JAVA_OPTS:-'-Xms2048M -Xmx2048M'}
JAVA_OPTS="-server $JAVA_OPTS -Duser.timezone=GMT+08 -Dfile.encoding=UTF-8 -Djava.security.egd=file:/dev/./urandom -javaagent:/usr/local/share/icop-config-agent.jar -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=54321"

if [ $PP_APPLICATION_NAME ];then
  ip=`hostname -i`
  CATALINA_OPTS="$CATALINA_OPTS -javaagent:/usr/local/pinpoint-agent/pinpoint-bootstrap-1.8.0.jar"
  CATALINA_OPTS="$CATALINA_OPTS -Dpinpoint.agentId=$ip"
  CATALINA_OPTS="$CATALINA_OPTS -Dpinpoint.applicationName=$PP_APPLICATION_NAME"
  JAVA_OPTS="$JAVA_OPTS -Dpinpoint.container"
fi
