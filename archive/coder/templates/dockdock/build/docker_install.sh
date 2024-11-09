#!/bin/sh

set -e

curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli docker-compose-plugin containerd.io

sudo systemctl enable docker

curl -L "https://github.com/docker/compose/releases/download/2.28.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

apt-get autoremove -y 
apt-get clean autoclean 
rm -rf /var/lib/{apt,dpkg,cache,log} 