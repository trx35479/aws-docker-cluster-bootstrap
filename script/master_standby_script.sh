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
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA77uC5TWpSh8JLnbXiMG46AwDEH2ahrzBTQTLmiFNWewJhdV1
yqU/mS7yfCfqaEWknDuP9kN76JtdIM045szhFR9Jt9U8Crzj7iVX6c7LvnWQ/rps
eNhb0q0Zw5w5HN4qR01HrpLPPc/frsBsteIBnCCZC11iUEvlJcDbTzRODaL+OYKO
A4gjaaWj3Y92+nRTCJUQvU3Vt8GjTbvMXnTRwHaGunfXCURW3HEeieoTd4zAMo54
UKIT9znKW4LpjtrhEFEmo8sl7/RReMBjTG//ULCS6RKHCGKfr8YqQoN9IaxWOM1C
4kS7M3dYQbW5j8F0TR2zHQDyf3hO1en1rxp4pwIDAQABAoIBAGJiggWvUBqrQglf
nHTzi/8vbtKFubUyIeKJ5UUMBcKxq/bQ89aGmuMy8TEi8IB6lGPJzfszFtcPa9ja
YE/YJUeV35siV9HQU3qYuMurotI3TZo8x+eQY57Ci6BLrOS8CH3aqWBrv8GOXi5J
qlO6vQ5mEmknmgF6JECqNVb8EExnnLKTmhz1HsPcvppI1FT3IRYZy2cPiopW1cMo
aeMJe77VPYLgaA17r6v/Xcb0UfjNF1U6BaSK5Xr+pdUJQXVaD89UeV2uQewbcarL
D/py9B4rZM8OQx17StjEIzd5G/81Ee7vs/P4w5SS+BqfgmXolqRUfHaQk+1R6BGU
R4YPiQECgYEA+v3oPNPcQfqeO9vcWFqraBJfHgfAeu8NoJB8BXxgMM+MqemkGc8V
PEsRbE2xf2wlXQJEqbpNbtY7SNBO8QJrwCnb8czhW5T9g9pD74CvVgOCYW8Kxsbw
I4lWVbj5RF2Wz+tfwAwjiZQAi3hUvmRhttCZ2e84VeZiSRPhHuTeprkCgYEA9IQX
Ewvj9tI2cMXHYy0ASzxQILFWDtlxJ3+Ww0V+e2YD8GJIvxMpfwGe9LnXLgmV1bBZ
/6NsJ5Xp8GBEDUX3YRPMsMiGgD5byviFVb4Ev61uvGsTm+YWkxt7SkyopZMJVJ4g
RbupkvY1CsqtTpKsrftrUnLznCk/2d17RlICal8CgYEApqEsrj1k6/SrWkgTmCDR
zOztcu1ojvTn0iI6BBZXcfBIjYFMbcn6aiXYMlO+ND8i6wWXeiryP1RA1Y1d60lV
KaVgnL4NGxTl3cRo97cyMGNyCqeCuwbV5HHH/G8qJYYQmobD8abdbPfyCKXhdOkF
qi4BBht4BidGNwfYm/8MBhkCgYBu9ma2SQYZ44m7IbX7RtfETMmcHH4OXRUhtKAJ
W8crXr9Y3nFe7OY+8dBeBNwm00jA4bfl8BbL3Bd+82DOmTrLPj381/NZzXLAqIlx
wLrM9Xq0XO9YJ1GFTspjjGhYQ2LPmLbSjnhE7iBiFloRtzRP/DHXB72P15RXXVBt
OBhKhwKBgA3hP8vpK26IaPaygeb28Zvrw+qmMFi7bPVT6oQ5Q3fFlRWBtET1z3mr
P/BgWZF/Xr2qE1k4NVoIygpzwXvQBhRDuKtopUfFKMXTnA5A64ti2Mm8T4E1ovnx
FBp0jFv0oDrtPvjBOozoa+rzI67A9vAtu6qVnRNdDFj3Jfi8zVQV
-----END RSA PRIVATE KEY-----" > /home/ubuntu/mykey.pem

sudo chmod 0400 /home/ubuntu/mykey.pem
sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i /home/ubuntu/mykey.pem \
           ubuntu@${master_ip}:/home/ubuntu/manager-token .
sudo docker swarm join --token $(cat /manager-token) ${master_ip}:2377
sudo rm -f /home/ubuntu/mykey.pem
