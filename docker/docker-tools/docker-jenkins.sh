#!/bin/bash

# setup&run jenkins
# lvhfa@yonyou.com 2016/07/03

set -e

mkdir -p /data/docker_mount/jenkins

cat > /data/docker_mount/jenkins/log.properties <<EOF
handlers=java.util.logging.ConsoleHandler
jenkins.level=FINEST
java.util.logging.ConsoleHandler.level=FINEST
EOF

chown -R 1000:1000 /data/docker_mount/jenkins


docker run -d -p 8001:8080 -p 50000:50000 --name jenkins --restart=always \
        -v /data/docker_mount/jenkins:/var/jenkins_home \
	-e JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties" \
        jenkins
