#!/bin/bash

# setup&run zk
# lvhfa@yonyou.com 2016/04/19

set -e

mkdir -p /data/docker_mount/zookeeper/data/zookeeper
mkdir -p /data/docker_mount/zookeeper/conf/

cat > /data/docker_mount/zookeeper/conf/zoo.cfg <<EOF
clientPort=2181
dataDir=/data
dataLogDir=/datalog
tickTime=2000
initLimit=5
syncLimit=2
EOF


docker run -d -p 2181:2181 --name zookeeper --restart=always \
	-v /data/docker_mount/zookeeper/conf/zoo.cfg:/conf/zoo.cfg \
	-v /data/docker_mount/zookeeper/data/zookeeper:/data \
	-v /data/docker_mount/zookeeper/datalog:/datalog \
	zookeeper