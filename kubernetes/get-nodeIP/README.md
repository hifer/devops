# k8s

### 部署nginx-deploy和service
```
kubectl apply -f https://raw.githubusercontent.com/hifer/k8s/master/nginx-demo.yaml
```

### 验证
```
[root@iZ2ze3gy99qf89c9yk6rw7Z ~]# while true;do curl 10.99.99.99;sleep 1;done
Node:iz2ze3gy99qf89c9yk6rw3z
Pod:nginx-deploy-7b68fb7859-c8wmt-172.18.4.19
Node:iz2ze3gy99qf89c9yk6rw5z
Pod:nginx-deploy-7b68fb7859-tml94-172.18.5.19
Node:iz2ze3gy99qf89c9yk6rw3z
Pod:nginx-deploy-7b68fb7859-c8wmt-172.18.4.19
Node:iz2ze3gy99qf89c9yk6rw2z
Pod:nginx-deploy-7b68fb7859-k2zvv-172.18.3.45
```

### 删除nginx-deploy和service
```
kubectl delete -f https://raw.githubusercontent.com/hifer/k8s/master/nginx-demo.yaml
```
