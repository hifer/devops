#!/bin/env bash

# program: init host
# author: lvhfa@yonyou.com
# date: 2020/05/26

# import utils
scripts_dir=$(cd "$(dirname "$0")"; pwd)
. $scripts_dir/utils.sh

init_host() {
init_host_result=`cat $scripts_dir/.init_host_result`
if [ "x0" == x"$init_host_result" ];then
  print_green "主机已初始化成功"
  return 0
fi

# selinux disabled
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
print_green "SELINUX已禁用"


# shutdown firewalld
systemctl stop firewalld
systemctl disable firewalld
print_green "防火墙已关闭并禁用"

#mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.$time
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
#yum clean all
#yum makecache
if [ $? -eq 0 ];then
  print_green "使用阿里云yum源"
else
  print_red "更换阿里云yum源失败"
fi

# aliyun docker-ce repo
command -v yum-config-manager &> /dev/null
if [ $? -eq 0 ];then
  yum -y install yum-utils
fi
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
if [ $? -eq 0 ];then
  print_green "添加docker阿里云yum源"
else
  print_red "添加docker阿里云yum源失败"
fi

# init_host_result
init_status=$result
echo "scripts_dir" + $scripts_dir
echo "init_status:" + $init_status
echo $init_status > $scripts_dir/.init_host_result

}


main() {
init_host;
}

main "$@"
