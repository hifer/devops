# 配置集群信息cluster-info
CP0/CP1/CP2为三台主节点IP，VIP：api-server代理三个主节点IP（四层代理），NET_IF：网卡名，CIDR：为POD划分的子网地址
``` shell
# 创建集群信息文件
$ cat ./cluster-info
CP0_IP=10.3.78.180
CP1_IP=10.3.78.181
CP2_IP=10.3.78.182
VIP=10.3.78.180
NET_IF=eth0
CIDR=172.18.0.0/16

```

## 初始化主机,每台主机都需运行
检查操作系统版本和磁盘格式，并安装配置指定版本的docker、kubelet、kubeadm、kubectl等工具
``` shell
./init_host.sh
```

## 主节点运行
运行以下脚本后cluster-info中的CP0/CP1/CP2初始化为集群主节点
``` shell
./kubeadm-ha.sh
```

## 生成token
在一台主节点上执行命令
``` shell
[root@iZ2ze3gy99qf89c9yk6rw7Z kubeadm-v1.13.5]# kubeadm token create --print-join-command
kubeadm join 10.3.78.180:5443 --token s7t7bq.qnnbfs1g82vm57zx --discovery-token-ca-cert-hash sha256:c788d1b61e9b5621c4e92b3529194119915cf30e87f84bc4a0922e66967a0137
```
生成的命令在工作节点执行，执行后会加入到k8s的集群管控

