#!/bin/bash
#
# Setup the the box. This runs as root

apt-get -y update

apt-get -y install curl

# You can install anything you need here.
curl -sSL https://get.docker.com/ | sh

usermod -aG docker vagrant

docker pull progrium/consul
docker pull gliderlabs/registrator
docker pull swarm
docker pull diasjorge/haproxy-demo
docker pull diasjorge/sinatra-demo
docker pull redis
