#FROM 192.168.0.146:5000/yonyoucloud-middleware/tomcat:8.0.50-jdk8-alpine-lvhf
FROM 192.168.0.146:5000/yonyoucloud-middleware/tomcat:8.0.50-jdk8-alpine-cscec

LABEL maintainer="lvhfa<lvhfa@yonyou.com>"

#icop-config-agent
ARG CONFIG_VERSION=${CONFIG_VERSION:-1.3\-SNAPSHOT}
ARG CONF_AGENT_INSTALL_URL=https://ops.yonyouccs.com/resources/icop-config-agent/${CONFIG_VERSION}/icop-config-agent-${CONFIG_VERSION}.jar
RUN mkdir -p /usr/local/share \
    && wget ${CONF_AGENT_INSTALL_URL} -O /usr/local/share/icop-config-agent.jar

# cas auth
ADD cas/* /data/icop-conf/

COPY entrypoint.sh /usr/local/tomcat/bin/

ADD printenv.jar /usr/local/share/
