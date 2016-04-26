#!/bin/bash

# Get dockerfile/ubuntu image
docker build -t="dockerfile/ubuntu" github.com/dockerfile/ubuntu

# jdk7 from local Dockerfile
docker build -t dockerfile/java:openjdk-7-jdk .

# Create volume, copy the java project code, to be loaded by both client and server containers
docker build -t ubuntu:volume volume_docker/
docker create -v /data --name dbstore ubuntu:volume /bin/true

# Create network bridge
docker network create -d bridge my-bridge-network

# Make project
docker run -it -P --net=my-bridge-network --volumes-from dbstore --rm dockerfile/java:openjdk-7-jdk /bin/bash -c "cd /data/; make"

# Run server, and then client
docker run -d -P --net=my-bridge-network --volumes-from dbstore --name server dockerfile/java:openjdk-7-jdk java docker/PingPongServer server
sleep 1
docker run -d -P --net=my-bridge-network --volumes-from dbstore --name client dockerfile/java:openjdk-7-jdk java docker/PingPongClient server

# Check client logs
sleep 3
docker logs client > client.out

./test.sh
