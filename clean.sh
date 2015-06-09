export DOCKER_HOST=tcp://172.20.20.10:12375
unset DOCKER_TLS_VERIFY

docker ps | grep haproxy | awk '{print $1}' | xargs docker rm -f
docker ps | grep redis | awk '{print $1}' | xargs docker rm -f
docker ps | grep sinatra | awk '{print $1}' | xargs docker rm -f
