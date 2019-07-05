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
echo "${private_key}" > /home/ubuntu/mykey.pem

sudo chmod 0400 /home/ubuntu/mykey.pem
sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i /home/ubuntu/mykey.pem \
           ubuntu@${master_ip}:/home/ubuntu/manager-token .
sudo docker swarm join --token $(cat /manager-token) ${master_ip}:2377
sudo rm -f /home/ubuntu/mykey.pem
