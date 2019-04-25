#!/bin/bash

# rancher ha 
# lvhfa@yonyou.com 2017/10/18

sudo echo "Asia/Shanghai" > /etc/timezone

mkdir -p /gitdata/gitlab/{config,logs,data}

sudo docker run --detach \
    --hostname 10.3.34.12 \
    --env GITLAB_OMNIBUS_CONFIG="external_url 'http://git.yonyouccs.com/'; gitlab_rails['lfs_enabled'] = true;" \
    --publish 443:443 --publish 10080:80 --publish 10022:22 \
    --name gitlab \
    --restart always \
    --volume /etc/localtime:/etc/localtime \
    --volume /etc/timezone:/etc/timezone \
    --volume /gitdata/gitlab/config:/etc/gitlab \
    --volume /gitdata/gitlab/logs:/var/log/gitlab \
    --volume /gitdata/gitlab/data:/var/opt/gitlab \
    gitlab/gitlab-ce:latest