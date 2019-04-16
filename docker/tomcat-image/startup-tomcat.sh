#!/bin/sh

echo "starting--tomcat.." >> /tmp/startup-tomcat.log

#config pinpoit collector
COLLECTOR_IP=${COLLECTOR_IP:-"pp-server"}
sed -i "/profiler.collector.ip=/ s/=.*/=${COLLECTOR_IP}/" /usr/local/pinpoint-agent/pinpoint.config

warname=`ls -1 /usr/local/tomcat/webapps | grep -v healthcheck`
echo $warname >> /tmp/startup-tomcat.log
if [ -d "/usr/local/tomcat/share/" ]; then
    `mv /usr/local/tomcat/share/* /usr/local/tomcat/webapps/$warname/WEB-INF/lib/`
     echo "mv-jar-end" >> /tmp/startup-tomcat.log 
fi

date >> /tmp/startup-tomcat.log
echo "ready-tomcat.." >> /tmp/startup-tomcat.log 
sh /usr/local/tomcat/bin/catalina.sh run


