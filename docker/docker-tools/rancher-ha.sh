#!/bin/bash

# rancher ha 
# lvhfa@yonyou.com 2017/10/18

sudo echo "Asia/Shanghai" > /etc/timezone

sudo docker run -d --restart=unless-stopped -p 8081:8080 -p 9345:9345 --name rancher \
    -v /etc/localtime:/etc/localtime \
    -v /etc/timezone:/etc/timezone \
    rancher/server:stable \
    --db-host 192.168.220.49 --db-port 3306 --db-user root --db-pass P@ssw0rd01! --db-name cattle \
    --advertise-address 192.168.220.50
