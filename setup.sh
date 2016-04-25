#!/bin/bash

# Get dockerfile/ubuntu image
docker build -t="dockerfile/ubuntu" github.com/dockerfile/ubuntu

# jdk7 from local Dockerfile
docker build -t dockerfile/java:openjdk-7-jdk .

docker build -t ubuntu:volume volume_docker/
docker create -v /data --name dbstore ubuntu:volume /bin/true

docker network create -d bridge my-bridge-network

docker run -it -P --net=my-bridge-network --volumes-from dbstore --rm dockerfile/java:openjdk-7-jdk /bin/bash -c "cd /data/; make"

docker run -d -P --net=my-bridge-network --volumes-from dbstore --name server dockerfile/java:openjdk-7-jdk java docker/PingPongServer
docker run -d -P --net=my-bridge-network --volumes-from dbstore --name client dockerfile/java:openjdk-7-jdk java docker/PingPongClient server
