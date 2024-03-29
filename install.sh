#!/bin/sh
#!/bin/bash

# Stop on errors
set -e

# Update system package list
sudo apt-get update

# Install Python3, pip, and other utilities
sudo apt-get install -y python3 python3-pip python3-venv git

# Upgrade pip and install virtualenv
python3 -m pip install --upgrade pip
python3 -m pip install virtualenv

# Install Ansible
pip install ansible

# Run an Ansible playbook
ansible-playbook dev_setup.yml

echo "Installation complete!"


export DEBIAN_FRONTEND=noninteractive
sudo apt update -y

# Install python3
sudo apt install \
    python3 \
    python3-pip \
    python3-apt

# Install ansible via pip
python3 -m pip install --upgrade pip
pip install --user ansible ansible-lint

# Run an Ansible playbook
cd ansible
ansible-playbook dev_setup.yml
cd ..

echo "Installation complete!"