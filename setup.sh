#!/bin/bash
echo "Copy project files"
cp -rf ../project1 volume_docker/

echo "Get necessary docker images"
# Get dockerfile/ubuntu image
docker build -t="dockerfile/ubuntu" github.com/dockerfile/ubuntu

# jdk7 from local Dockerfile
docker build -t dockerfile/java:openjdk-7-jdk .

echo "Create data volume"
# Create volume, copy the java project code, to be loaded by both client and server containers
docker build -t ubuntu:volume volume_docker/
docker create -v /data --name dbstore ubuntu:volume /bin/true

echo "Create network bridge"
# Create network bridge
docker network create -d bridge my-bridge-network

echo "Compile"
# Make project
docker run -it -P --net=my-bridge-network --volumes-from dbstore --rm dockerfile/java:openjdk-7-jdk /bin/bash -c "cd /data/; make"

echo "Run client and server container"
# Run server, and then client
docker run -d -P --net=my-bridge-network --volumes-from dbstore --name server dockerfile/java:openjdk-7-jdk java docker/PingPongServer server
sleep 1
docker run -d -P --net=my-bridge-network --volumes-from dbstore --name client dockerfile/java:openjdk-7-jdk java docker/PingPongClient server

# Check client logs
echo "Logs will print out in 3 sec"
sleep 3
docker logs client
docker logs client > client.out

echo "Start verifying logs"
./test.sh
