#!/bin/bash
docker run -it -P --net=my-bridge-network --volumes-from dbstore --name client dockerfile/java:openjdk-7-jdk
