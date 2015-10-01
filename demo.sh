#!/bin/sh

vagrant up

function go_next {
    echo ''
    read -e -p "$1. Continue? "
}

open http://172.20.20.10:8500/ui

export DOCKER_HOST="tcp://172.20.20.10:12375"
unset DOCKER_TLS_VERIFY

go_next 'Starting redis container'
docker run -d -P redis

go_next 'Starting haproxy container'
docker run -d -p 80:80 --dns 172.17.42.1 -e SERVICE_NAME=haproxy --name haproxy diasjorge/haproxy-demo

echo "haproxy running on $(docker inspect -f '{{ .Node.IP }}' haproxy)"

go_next 'Starting sinatra app container'
docker run -d -P --dns 172.17.42.1 -e SERVICE_NAME=sinatra diasjorge/sinatra-demo

go_next 'Starting another sinatra app container'
second=$(docker run -d -P --dns 172.17.42.1 -e SERVICE_NAME=sinatra diasjorge/sinatra-demo)
echo $second

go_next "Stopping container $second"
docker stop $second