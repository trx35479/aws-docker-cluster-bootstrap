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
MIIEpAIBAAKCAQEA0SXELwSYeRslwB4KttzuIt4Fn0FDNCEU3hOJB8d2Cf/ZDwrf
UHGiNYr7xomDYN2EIKQh/rHeu7/j8E5Grh7xTZSgw51qjUyL113SDTQOuc3qjmVL
ZWiAdAyS4oXIUAGXh0LSc7YNgJ3vIixdHw7d6SzLWmhKG/iRGNuYnCldlMQJvY0r
DPUtbh6WYn6HcPtjDIW+lBH3KEjF+Q7to3Q6RXHCt6/smPMu5rgY8lBVCWcn3gQq
diuP5KJi6WbEitEKAKL1Td2wVpJWe5pppV4d+j1Ir89hQtSAhoVGCHaiv9vUeYL8
f1Ocm38YqnUpSm+k+1zQAC8aRjX48SlKsutLjwIDAQABAoIBAQCuDLrN0go9Ro1M
6vNJqGP42kFdfcc6e4lNIn633ZLq0WLGdOrQnDA8VLQgTdHqa44IR+8OcOGF5zP+
iHWjc5amVFjRUZAZlKkPikFCwZ67m5Rl+gAbnTLA4LHgFytTAXAjnUVcDBYCgew+
ySKZtRqRcLiuPPnnexzszdqbooUBRf0o8xG2Vh3WvoRlsUxdB7BTX+zLiHYmUO8O
ARq2Dd3E6BlTVX45bd71hDthhbbhPuowl5HIoSL9SyCet2hklhnpyYMsHiq4J7X2
utwvBH69nQ0abrSocw5gdAT1U3NgfVVTpWQvKV2W18YCCdrnfFF4ou9vm4PNIWny
QmStp/FxAoGBAPhjIAIPo4ukaqPFlerqtFNygFS6A4J+Ho4Ciw2JWBjfyq6RM29X
xcz3wBHL21svyCpC7rYi+YHjY3JiiUbv2zskqHlmt5phmWrBMrjLQbYgxPJ28DxU
sqYncw+hdltlEy5kz0U5P04tCw7mHORX5b3DvU4zhvq/oS8UtMMTG3u5AoGBANeO
wx7yiHqwPwzpa6LpTxrHCf+lTPc57JwNEFdjFUOd2Te99+OU7NlhuWI+5JNz/WzJ
nY5/RrWovym1YHa1w8E4KOSFpU4Uipq/QmTCi2E1BnzkkMxSrAcgDceQXc0ZDn6j
Yit2s2NcS60VE10BtoYENYEtY3y4R3JrlGRmrfWHAoGASI1zwQZeaCCrgZDqXIcY
CzPr5lO7SLecJzD4+wg+Mm3UHy+MjZ5eyaMoeEpKlZUca7PHVG5c4SLRXo0Hui+/
osPvbh6hzLdrf7JVJYNBe3iQ7p3tSEIZOM1XH56zGrkoZCnQHVE+e5BOpZhzogNG
uSpetmP4rm+hHkZ3EnAXXAkCgYBzooUv0+G9F1ErhwiT417pOX82oiFwuqUgba2n
g2LD3CjLy1/wuVJ5pwABIUYTh/SaaGnaKJLxHq42HLO72vRBcfQV60/rW/+i1hky
3l5Q7lYlp6O5yFu6kspxlROM0/U/oDwonsvK8Jc0KYsyqJmWuSlOu9+T53OEgQug
9Kg7fwKBgQDOyJxUodx1Yq1Vge5+cPlKZ3JLn89t2kRcawI4xX6evf75fYNHqKjL
NQYL7kMTsN9OvORdiYNexxtjFWDKSeY2JEvLMkKj/mgEIwJ5NOgcv0N6XicX5CHn
0Eg8CWFGqpXkA5jpsJ8TQZbQFrMC2CcaTMn4rEa/TqDc+UiI+Hq3yQ==
-----END RSA PRIVATE KEY-----" > /home/ubuntu/mykey.pem

sudo chmod 0400 /home/ubuntu/mykey.pem
sudo scp -o StrictHostKeyChecking=no -o NoHostAuthenticationForLocalhost=yes -o UserKnownHostsFile=/dev/null -i /home/ubuntu/mykey.pem \
           ubuntu@${master_ip}:/home/ubuntu/worker-token .
sudo docker swarm join --token $(cat /worker-token) ${master_ip}:2377
sudo rm -f /home/ubuntu/mykey.pem
