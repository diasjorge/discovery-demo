docker ps | grep haproxy | awk '{print $1}' | xargs docker rm -f
docker ps | grep redis | awk '{print $1}' | xargs docker rm -f
docker ps | grep sinatra | awk '{print $1}' | xargs docker rm -f
