#!/bin/env bash

# program: install docker
# author: lvhfa@yonyou.com
# date: 2020/05/27

# import utils
scripts_dir=$(cd "$(dirname "$0")"; pwd)
. $scripts_dir/utils.sh


#安装docker
install_docker() {

command -v docker &> /dev/null
if [ $? -eq 0 ];then
  docker_version=`docker -v | cut -d ' ' -f3 | cut -d ',' -f1`
  if [ x"$docker_version" == x"$recommend_docker_version" ];then
    print_green "您已安装$docker_version版本docker"
    config_docker;
    return 0;
  else
    print_green "请使用docker $recommend_docker_version-ce 是否卸载当前版本docker $docker_version？[Y/N]"
    read answer
    case $answer in
    Y | y) 
    uninstall_docker;;
    N | n)
    print_green "请您自行卸载docker $docker_version"
    exit 3;;
    *)
    print_green "请输入Y(yes)或者N(no)"
    install_docker;;
  esac
  fi
fi

yum install -y yum-utils device-mapper-persistent-data lvm2
yum install -y https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.13-3.2.el7.x86_64.rpm
yum install -y https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-19.03.9-3.el7.x86_64.rpm
yum install -y https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-19.03.9-3.el7.x86_64.rpm


if [ $? -ne 0 ]; then
  print_red "安装docker失败，请检查报错信息"
  exit 4
else
  print_green "docker安装成功,开始配置docker..."
  config_docker;
fi
}

#配置docker
config_docker() {

mkdir -p  ~/.docker
cat > ~/.docker/config.json <<EOF
{
        "auths": {
                "harbor.yonyouccs.com": {
                        "auth": "c2V0dXA6THZoYWlmZW5nLTEyMw=="
                }
        }
}
EOF

mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "data-root": "/data/docker",
  "registry-mirrors": ["https://q2uvt0x7.mirror.aliyuncs.com"],
  "insecure-registries": ["harbor.yonyouccs.com"]
}
EOF

}

uninstall_docker(){
sudo yum remove -y docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine
rm -rf /var/lib/docker
rm -rf /data/docker
rm -rf /etc/docker/daemon.json
rm -rf ~/.docker/config.json
rm -rf /usr/lib/systemd/system/docker.service
rm -rf /etc/systemd/system/docker.service
}


start_docker() {

systemctl daemon-reload
systemctl enable docker
systemctl restart docker

sleep 3

docker info  > /dev/null 2>&1
if [ $? -ne 0 ]; then
  print_red "docker启动失败，请检查报错信息"
else
  print_green "docker启动成功"
fi

docker_status=$result
echo $docker_status > $scripts_dir/.install_docker_result

}

main() {
install_docker;
start_docker;
}

main "$@"
