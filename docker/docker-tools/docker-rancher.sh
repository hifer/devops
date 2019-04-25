#!/bin/bash

docker run -d --restart=unless-stopped -p 8080:8080 -p 3306:3306 --name rancher-server \
        -v /data/docker_mount/rancher_mysql:/var/lib/mysql \
        rancher/server:stable

