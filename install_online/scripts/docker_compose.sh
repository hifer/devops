#!/bin/env bash

# program: docker-compose install
# author: lvhfa@yonyou.com
# date: 2020/05/27

# import utils
scripts_dir=$(cd "$(dirname "$0")"; pwd)
. $scripts_dir/utils.sh

# install docker-compose
curl -L "https://get.daocloud.io/docker/compose/releases/download/$recommend_docker_compose_version/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose  > /dev/null 2>&1
chmod +x /usr/local/bin/docker-compose

