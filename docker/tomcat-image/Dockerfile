FROM tomcat:8.5.35-jre8-alpine

LABEL maintainer="lvhfa<lvhfa@yonyou.com>"

# modify timezone
RUN apk --no-cache add tzdata && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone

#add curl telnet
RUN apk --no-cache add curl busybox-extras fontconfig

# install pinpoint agent and modify conf
ARG PINPOINT_VERSION=${PINPOINT_VERSION:-1.8.0}
ARG PP_INSTALL_URL=https://ops.yonyouccs.com/resources/pinpoint/${PINPOINT_VERSION}/pinpoint-agent-${PINPOINT_VERSION}.tar.gz
ARG PROFILER_SAMPLING_RATE=${PROFILER_SAMPLING_RATE:-1}

RUN mkdir -p /usr/local/pinpoint-agent \
    && wget ${PP_INSTALL_URL} -O pinpoint-agent.tar.gz \
    && tar -xf pinpoint-agent.tar.gz -C /usr/local/pinpoint-agent \
    && rm -rf pinpoint-agent.tar.gz \
    && sed -i "/profiler.sampling.rate=/ s/=.*/=${PROFILER_SAMPLING_RATE}/" /usr/local/pinpoint-agent/pinpoint.config

# add config agent
ARG CONFIG_VERSION=${CONFIG_VERSION:-1.3\-SNAPSHOT}
ARG CONF_AGENT_INSTALL_URL=https://ops.yonyouccs.com/resources/icop-config-agent/${CONFIG_VERSION}/icop-config-agent-${CONFIG_VERSION}.jar
RUN mkdir -p /usr/local/share \
    && wget ${CONF_AGENT_INSTALL_URL} -O /usr/local/share/icop-config-agent.jar

# cas auth
ADD cas/* /data/icop-conf/

# sys fonts
#ADD ttf/* /usr/share/fonts/

# modify catalina add pinpoint agent config
#ADD catalina.sh /usr/local/tomcat/bin/
#RUN chmod +x /usr/local/tomcat/bin/catalina.sh

ADD setenv.sh /usr/local/tomcat/bin/
RUN chmod +x /usr/local/tomcat/bin/setenv.sh

# tomcat start up script
ADD startup-tomcat.sh /usr/local/tomcat/bin/
RUN chmod +x /usr/local/tomcat/bin/startup-tomcat.sh

# tomcat server.xml
ADD server.xml /usr/local/tomcat/conf/

#del tomcat org project and add health check index.html
RUN rm -rf /usr/local/tomcat/webapps/* \
    && mkdir -p /usr/local/tomcat/webapps/healthcheck \
    && echo "ok" > /usr/local/tomcat/webapps/healthcheck/index.html


EXPOSE 8080

ENTRYPOINT ["sh","/usr/local/tomcat/bin/startup-tomcat.sh"]
