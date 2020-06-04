#!/bin/env bash

# program: note message color
# author: lvhfa@yonyou.com
# date: 2020/05/25

# version info
# support centos version list
support_os_version=("7.4.1708" "7.5.1804" "7.6.1810" "7.7.1908" "7.8.2003")
# recommend docker version
recommend_docker_version="19.03.9"
# recommend docker-compose version
recommend_docker_compose_version="1.24.1"

# time
time=$(date "+%Y%m%d%H%M%S")

# note message: green--right red--error
# defult result 0--green--right
result=0
reset_color="\033[0m"
print_green(){
  echo -e "\033[42;1m"${1}${reset_color}
}

print_red(){
  echo -e "\033[41;1m"${1}${reset_color}
  result=1
}

# install stage result
install_stage_result() {
install_code=`cat $1`
if [ "x0" != x"$install_code" ];then
  print_red "安装失败,退出安装"
  exit 1
else
  return 0 
fi
}
