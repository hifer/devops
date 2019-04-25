#!/bin/bash

# setup&run mq
# lvhfa@yonyou.com 2016/04/19

set -e

mkdir -p /data/docker_mount/rabbitmq/rabbitmq_data

cat > /data/docker_mount/rabbitmq/rabbitmq.config <<EOF
[ { rabbit, [
        { loopback_users, [ ] },
        { tcp_listeners, [ 5672 ] },
        { ssl_listeners, [ ] },
        { default_pass, <<"admin">> },
        { default_user, <<"admin">> },
        { hipe_compile, false }
] } ].
EOF

chmod 777 /data/docker_mount/rabbitmq/rabbitmq.config

docker run -d -p 5672:5672 --name rabbitmq --restart=always \
	-e RABBITMQ_DEFAULT_USER=admin \
	-e RABBITMQ_DEFAULT_PASS=admin \
	-v /data/docker_mount/rabbitmq/rabbitmq_data:/var/lib/rabbitmq \
	-v /data/docker_mount/rabbitmq/rabbitmq.config:/etc/rabbitmq/rabbitmq.config \
	rabbitmq:management
