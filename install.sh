#!/bin/sh
#!/bin/bash

# Stop on errors
set -e

export TOOLBOX_PATH=$HOME/.toolbox
export TOOLBOX_BIN_PATH=$TOOLBOX_PATH/bin

# Update system package list
sudo apt-get update

# Install Python3, pip, and other utilities
sudo apt-get install -y python3 python3-pip python3-venv git

# Upgrade pip and install virtualenv
python3 -m pip install --upgrade pip
python3 -m pip install virtualenv

# Install Ansible
pip install ansible ansible-lint

# Run the playbook
cd ansible
ansible-playbook playbook.yml
cd ..

echo "Installation complete!"