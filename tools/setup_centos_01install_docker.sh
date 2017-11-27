#!/bin/bash

#THIS IS EXAMPLE SETUP SCRIPT. YOU NEED TO RUN MANUALLY.

DOCKER_PKG=docker-ce-17.09.0.ce-1.el7.centos

#remove default docker files
sudo yum remove docker docker-common docker-selinux docker-engine

#install needed packages
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

#setup yum
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum makecache fast

yum list docker-ce.x86_64 --showduplicates | sort -r
sudo yum install -y $DOCKER_PKG

sudo systemctl daemon-reload
sudo systemctl enable docker
docker --version

