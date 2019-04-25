#!/bin/bash

docker run -d -p 80:80 -p 22122:22122 --name fastdfs --restart=always \
        -e "HOST_IP=192.168.0.88" \
        -v /data/docker_mount/fastdfs:/data/fastdfs \
        base/fastdfs:1.5