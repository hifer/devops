#!/bin/env bash

# program: check host
# author: lvhfa@yonyou.com
# date: 2020/05/25

# import utils
scripts_dir=$(cd "$(dirname "$0")"; pwd)
. $scripts_dir/utils.sh

# check os centos7 release
check_os() {

os_version=`cat /etc/redhat-release |awk '{print $4}'`

if [ ! $os_version ]; then
  print_red "请使用如下${#support_os_version[@]}个版本CentOS Linux release ${support_os_version[*]} (Core)版本操作系统"
  exit 1
fi

for version in ${support_os_version[@]}
  do
    if [ x"$version" == x"$os_version"  ];then
      in_os_list=0
      break
    else
      in_os_list=1
    fi
  done

if [ $in_os_list == 0 ];then
  print_green "当前操作系统版本符合安装要求"
else
  print_red "您当前操作系统版本CentOS Linux release $os_version (Core),不符合安装要求"
  print_red "请使用如下${#support_os_version[@]}个版本CentOS Linux release ${support_os_version[*]} (Core)版本操作系统"
fi
}


# check data disk filesystem ext4
check_disk() {

data_avail_size=`df -Th|grep -w data|grep ext4 |awk '{print $5}' |sed 's/.$//g'`

if [ "x" == x"$data_avail_size" ];then
  print_red "请挂载ext4文件格式的磁盘到/data目录"
elif [ $data_avail_size -lt 190 ];then
  print_red "/data磁盘可用空间不足200G"
else
  print_green "当前数据盘:/data符合安装要求"
fi
}


# check network
check_network() {
ping mirrors.aliyun.com -c 3 -W 5 > /dev/null 2>&1

if [ $? -eq 0 ];then
  print_green "当前网络符合安装要求"
else
  print_red "当前网络无法访问互联网，请检查"
fi
}

# check result: 0--pass 1--not pass
check_result() {
host_status=$result
echo $host_status > $scripts_dir/.host_status
}

# main
main() {
check_os;
check_disk;
check_network;
check_result;
}

main "$@"

