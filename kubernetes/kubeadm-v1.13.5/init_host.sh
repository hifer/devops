#!/bin/env bash
#program:init k8s host
#author:lvhfa@yonyou.com
#date:20190312

#support os list
support_os_version=("7.4.1708" "7.5.1804" "7.6.1810")

#check os
check_os() {
os_version=`cat /etc/redhat-release |awk '{print $4}'`
if [ ! $os_version ]; then
  echo -e "\033[41;1m 请使用如下${#support_os_version[@]}个版本CentOS Linux release ${support_os_version[@]} (Core)版本操作系统 \033[0m";
  exit 1
fi
for version in ${support_os_version[@]}
  do
    if [ x"$version" == x"$os_version"  ];then
      flag=1
      break
    else
      flag=0
    fi
  done
if [ $flag == 1 ];then
  echo -e "\033[42;1m 当前操作系统版本CentOS Linux release $os_version (Core),符合安装要求 \033[0m";
else
  echo -e "\033[41;1m 您当前操作系统版本CentOS Linux release $os_version (Core),不符合安装要求 \033[0m";
  echo -e "\033[41;1m 请使用如下${#support_os_version[@]}个版本CentOS Linux release ${support_os_version[@]} (Core)版本操作系统 \033[0m";
  exit 2;
fi
}

#check data disk xfs with ftype=1 or ext4
check_disk() {
data_xfs=`df -Th|grep -w data|grep xfs`
data_ext4=`df -Th|grep -w data|grep ext4`
command -v xfs_info &> /dev/null
if [ $? -ne 0 ];then
  yum install xfsprogs -y
fi
ftype=`xfs_info /data|grep ftype=1` &> /dev/null
if [ "x" != x"$data_xfs" ];then
  if [ "x" == x"$ftype" ];then
    echo -e "\033[41;1m 请在格式化磁盘时开启ftype=1,例如:mkfs.xfs -n ftype=1 /path/to/your/device \033[0m"
    exit 6;
  else
    echo -e "\033[42;1m 当前/data盘文件系统为xfs且ftype=1,符合安装要求 \033[0m";
    return 0
  fi
elif [ "x" != x"$data_ext4" ];then
    echo -e "\033[42;1m 当前/data盘文件系统为ext4,符合安装要求 \033[0m";
    return 0
else
  echo -e "\033[41;1m 请挂载xfs或ext4文件格式的磁盘到/data目录 \033[0m"
  exit 7;
fi
}

#shutdown firewalld swap,turn on kernel ipvs modules
init_host() {
systemctl stop firewalld
systemctl disable firewalld
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config

swapoff -a
yes | cp /etc/fstab /etc/fstab_bak
cat /etc/fstab_bak |grep -v swap > /etc/fstab

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

cat > /etc/sysconfig/modules/ipvs.modules <<EOF
#!/bin/env bash
ipvs_modules="ip_vs ip_vs_lc ip_vs_wlc ip_vs_rr ip_vs_wrr ip_vs_lblc ip_vs_lblcr ip_vs_dh ip_vs_sh ip_vs_fo ip_vs_nq ip_vs_sed ip_vs_ftp nf_conntrack"
for kernel_module in \${ipvs_modules}; do
 /sbin/modinfo -F filename \${kernel_module} > /dev/null 2>&1
 if [ $? -eq 0 ]; then
 /sbin/modprobe \${kernel_module}
 fi
done
EOF
chmod 755 /etc/sysconfig/modules/ipvs.modules && bash /etc/sysconfig/modules/ipvs.modules && lsmod | grep ip_vs

cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

command -v wget &> /dev/null
if [ $? -ne 0 ];then
  yum install -y wget
fi

wget http://mirrors.aliyun.com/repo/Centos-7.repo -O /etc/yum.repos.d/CentOS-Base.repo
wget http://mirrors.aliyun.com/repo/epel-7.repo -O /etc/yum.repos.d/epel.repo
}

#安装docker
install_docker() {
command -v docker &> /dev/null
if [ $? -eq 0 ];then
  docker_version=`docker version|grep Version|awk '{print $2}'|uniq`
  if [ x"$docker_version" == "x18.06.3-ce"  ];then
    echo -e "\033[42;1m 您已安装$docker_version版本docker \033[0m"
    config_docker;
    return 0;
  else
    echo -e "\033[41;1m 请使用docker 18.06.3-ce 是否卸载当前版本docker $docker_version？[Y/N] \033[0m"
    read answer
    case $answer in
    Y | y) 
    uninstall_docker;;
    N | n)
    echo -e "\033[42;1m 请您自行卸载docker $docker_version \033[0m"
    exit 4;;
    *)
    echo -e "\033[41;1m 请输入Y(yes)或者N(no) \033[0m"
    install_docker;;
  esac
  fi
fi

yum install -y yum-utils device-mapper-persistent-data lvm2
yum install -y https://mirrors.aliyun.com/docker-ce/linux/centos/7/x86_64/stable/Packages/docker-ce-19.03.8-3.el7.x86_64.rpm

if [ $? -ne 0 ]; then
  echo -e "\033[41;1m 安装docker失败，请检查报错信息 \033[0m"
  exit 5
else
  echo -e "\033[42;1m docker安装成功,开始配置docker... \033[0m"
  config_docker;
fi
}

#配置docker
config_docker() {
mkdir -p /etc/systemd/system/docker.service.d
cat >/etc/systemd/system/docker.service.d/docker.conf <<EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
ExecStartPost=/usr/sbin/iptables -P FORWARD ACCEPT
EOF
mkdir -p  ~/.docker
cat > ~/.docker/config.json <<EOF
{
        "auths": {
                "harbor.yonyouccs.com": {
                        "auth": "c2V0dXA6UEBzc3cwcmQwMSE="
                }
        }
}
EOF
mkdir -p /etc/docker
cat > /etc/docker/daemon.json <<EOF
{
  "data-root": "/data/docker",
  "exec-opts": ["native.cgroupdriver=cgroupfs"],
  "storage-driver": "overlay2", 
  "storage-opts":["overlay2.override_kernel_check=true"],
  "log-driver": "json-file", 
  "log-opts": { 
      "max-size": "100m", 
      "max-file": "10" 
  },
  "registry-mirrors": ["https://q2uvt0x7.mirror.aliyuncs.com"],
  "insecure-registries": ["harbor.yonyouccs.com"]
}
EOF
systemctl daemon-reload
systemctl enable docker
systemctl restart docker
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
}

install_kubeadm(){
yum install -y kubelet-1.13.5 kubeadm-1.13.5 kubectl-1.13.5 ipvsadm ipset
systemctl enable kubelet
}

main() {
check_os;
check_disk;
init_host;
install_docker;
install_kubeadm;
}

main "$@"
