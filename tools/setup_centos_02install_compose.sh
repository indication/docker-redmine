#!/bin/bash

#THIS IS EXAMPLE SETUP SCRIPT. YOU NEED TO RUN MANUALLY.

DOCKER_COMPOSE_VER=1.16.1

#setup docker-compose
curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VER/docker-compose-`uname -s`-`uname -m` > docker-compose_$DOCKER_COMPOSE_VER
sudo chmod +x docker-compose_$DOCKER_COMPOSE_VER
sudo mv docker-compose_$DOCKER_COMPOSE_VER /usr/local/sbin/ 
sudo ln -s /usr/local/sbin/docker-compose_$DOCKER_COMPOSE_VER  /usr/bin/docker-compose  
sudo docker-compose --version 

