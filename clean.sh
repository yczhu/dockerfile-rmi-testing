#!/bin/bash

docker stop client
docker stop server
docker rm client
docker rm server
docker rm dbstore
docker rmi ubuntu:volume
docker volume rm $(docker volume ls -qf dangling=true)
docker network rm my-bridge-network
rm client.out
