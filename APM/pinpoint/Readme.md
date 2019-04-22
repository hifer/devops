
# Pinpoint-Docker for Pinpoint

Official git repository of Dockerized components of the [Pinpoint Application Monitoring](http://naver.github.io/pinpoint/).  
Installing Pinpoint with these docker files will take approximately 10min. to check out the features of pinpoint.

## Version

 - 1.8.3

## Requirements

- [docker 18.02.0+](https://docs.docker.com/compose/compose-file/)

## Install Pinpoint


```
git clone https://github.com/naver/pinpoint-docker.git
cd pinpoint-docker
docker-compose pull && docker-compose up -d


This will install and run all services required to run all features in Pinpoint in docker containers joined with same network.
 - Pinpoint-Web Server
 - Pinpoint-Collector
 - Pinpoint-Zookeeper
 - Pinpoint-Hbase
 - Pinpoint-Mysql(to support certain feature)
This may take several minutes to download all necessary images.

 
## logs 
 
You can check logs produced by these services
 ```
 docker logs <containerId>
 ```
 
You can also easily change the log level from *.env* file. 
 
