#!/bin/bash

# setup webpush
# lvhfa@yonyou.com 2016/07/19

set -e

docker run -d --name=webpush -p 8081:8081 --restart=always \
        -e "jdbc_url=10.3.34.4:3306" \
        -e "jdbc_user=devuser" \
        -e "jdbc_password=devuser" \
        -e "redis_host=10.3.34.4" \
        -e "redis_port=6379" \
        -e "redis_auth=wvPjiSHOIpuF" \
        registry.dev.yonyouccs.com/base/webpush
