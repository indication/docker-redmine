#!/bin/bash

sudo cp docker-redmine.service  /etc/systemd/system/
sudo mkdir /usr/local/docker
sudo cp -R ../ /usr/local/docker/redmine
sudo chmod -R +w /usr/local/docker
sudo chcon -R system_u:object_r:usr_t:s0 /usr/local/docker

