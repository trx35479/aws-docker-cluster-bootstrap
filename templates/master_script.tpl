#!/bin/bash
sudo apt-get -y remove docker docker-engine docker.io 
sudo apt-get update -y
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get  -y install docker-ce docker-compose
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo systemctl enable docker
sudo systemctl start docker


# initialize docker

sudo docker swarm init
sudo docker swarm join-token --quiet worker > /home/ubuntu/worker-token
sudo docker swarm join-token --quiet manager > /home/ubuntu/manager-token
sleep 30

# install prometheus/grafana
git clone https://github.com/stefanprodan/swarmprom
cd /swarmprom
export ADMIN_USER=admin 
export ADMIN_PASSWORD=admin 
export SLACK_URL=https://hooks.slack.com/services/TOKEN 
export SLACK_CHANNEL=devops-alerts 
export SLACK_USER=alertmanager 
docker stack deploy -c docker-compose.yml mon
