export DOCKER_HOST=tcp://172.20.20.10:12375
unset DOCKER_TLS_VERIFY

docker ps -a | grep haproxy | awk '{print $1}' | xargs docker rm -f
docker ps -a | grep redis | awk '{print $1}' | xargs docker rm -f
docker ps -a | grep sinatra | awk '{print $1}' | xargs docker rm -f
