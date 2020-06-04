#!/bin/env bash

# program: install scripts
# author: lvhfa@yonyou.com
# date: 2020/05/25

chmod +x ./scripts/*.sh

install_dir=$(cd "$(dirname "$0")"; pwd)
. $install_dir/scripts/utils.sh

# check host
print_green "正在检测主机..."
./scripts/check_host.sh

# init host
install_stage_result $install_dir/scripts/.host_status
print_green "主机初始化..."
./scripts/init_host.sh

# install docker
install_stage_result $install_dir/scripts/.init_host_result
print_green "安装docker..."
./scripts/install_docker.sh

# install docker-compose
install_stage_result $install_dir/scripts/.install_docker_result
print_green "安装docker-compose..."
./scripts/docker_compose.sh

# start up middleware
print_green "启动中间件..."
command -v docker-compose &> /dev/null
if [ $? -eq 0 ];then
  docker-compose up -d
else
  print_red "未检测到docker-compose"
  exit 5
fi
