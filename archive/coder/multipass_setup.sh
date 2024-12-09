#!/bin/bash

# This script to be run on a fresh Ubuntu 20.04 LTS instance
# running on Multipass. It will install Docker, Tailscale, and Coder.
#
# The multipass instance can be created with the following command:
# multipass launch docker --name devbox --cpus 4 --memory 8G --disk 40G

sudo apt-get update
sudo apt-get install -y curl

# Install tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --auth-key $MULTIPASS_TS --ssh

# Not necessary when using the multipass docker blueprint.
# Install docker
# curl -fsSL https://get.docker.com -o get-docker.sh
# sudo sh get-docker.sh

# Install coder
curl -L https://coder.com/install.sh | sh

# Set coder.env
sudo bash -c 'cat <<EOF > /etc/coder.d/coder.env
CODER_HTTP_ADDRESS="0.0.0.0:80"
CODER_ACCESS_URL="http://coder.ecs.lan"
CODER_TLS_ENABLE=false
EOF'

# Add coder user to the docker group
sudo usermod -aG docker coder

# Start coder as a system service
sudo systemctl enable --now coder