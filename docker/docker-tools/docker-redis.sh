#!/bin/bash

# setup&run redis
# lvhfa@yonyou.com 2016/04/19
# qiany@yonyou.com 2018/7/28

set -e

if [ $# != 1 ] ; then 
  echo "USAGE: $0 xxxx" 
  exit 1; 
fi 

redisauth=$1

mkdir -p /data/docker_mount/redis/data

cat > /data/docker_mount/redis/redis.conf <<EOF
requirepass $redisauth
loglevel verbose
logfile /data/log/redis.log
dir /data
appendonly yes
appendfilename appendonly.aof
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb
aof-load-truncated yes
aof-use-rdb-preamble no
EOF

docker run -d -p 6379:6379 --name redis --restart=always \
	-v /data/docker_mount/redis/data:/data \
	-v /data/docker_mount/redis/redis.conf:/etc/redis/redis.conf \
	-v /data/middleware-log/redis:/data/log \
	registry.dev.yonyouccs.com/base/redis:c4.0.10 redis-server /etc/redis/redis.conf
