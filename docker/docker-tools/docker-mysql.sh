#!/bin/bash

# setup&run mysql
# lvhfa@yonyou.com 2016/04/19

set -e

mkdir -p /data/docker_mount/mysql/etc/mysql/conf.d
mkdir -p /data/docker_mount/mysql/var/log/mysql
mkdir -p /data/docker_mount/mysql/var/lib/mysql

server_id=`ifconfig eth0 | grep "inet" |grep -v inet6 |awk '{print $2}' |awk -F. '{print $4}'`
innodb_buffer_pool_size=`free -g|grep Mem |awk '{print $2}'`
((innodb_buffer_pool_size=$innodb_buffer_pool_size/2))
innodb_buffer_pool_size=$innodb_buffer_pool_size"G"

cat > /data/docker_mount/mysql/etc/mysql/conf.d/my.cnf <<EOF
[mysqld]
skip-name-resolve
server-id=$server_id
log-bin=mysql-bin.log
sync_binlog=1
innodb_buffer_pool_size=$innodb_buffer_pool_size
innodb_flush_log_at_trx_commit=1
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
lower_case_table_names=1
log_bin_trust_function_creators=1
replicate-wild-ignore-table=mysql.%
auto-increment-offset = 1
sync_master_info = 1
sync_relay_log = 1
sync_relay_log_info = 1
slave-net-timeout=60
max_connections = 3000
character-set-server=utf8
collation-server=utf8_general_ci
max_allowed_packet = 64M
thread_stack = 192K
innodb_thread_concurrency=0
# tmp & heap
tmp_table_size = 512M
max_heap_table_size = 512M
sort_buffer_size = 250K
innodb_sort_buffer_size = 250K
max_length_for_sort_data = 8192
read_buffer_size = 8M
join_buffer_size = 8M
innodb_log_buffer_size = 16M
innodb_log_file_size = 1G
innodb_autoextend_increment = 128M

#used by replication
master_info_repository = TABLE
relay_log_info_repository = TABLE
relay_log_recovery=1
auto-increment-increment = 1
[client]
default-character-set=utf8
EOF

docker run -d --network host --name mysql \
	-v /data/docker_mount/mysql/etc/mysql/conf.d:/etc/mysql/conf.d \
	-v /data/docker_mount/mysql/var/log/mysql:/var/log/mysql \
	-v /data/docker_mount/mysql/var/lib/mysql:/var/lib/mysql \
	-e MYSQL_ROOT_PASSWORD=P@ssw0rd01! \
	registry.dev.yonyouccs.com/base/mysql:yyccs0.01