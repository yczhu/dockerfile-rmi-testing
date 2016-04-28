#!/bin/bash
docker run -it -P --net=my-bridge-network --volumes-from dbstore --name server dockerfile/java:openjdk-7-jdk
