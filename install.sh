#!/bin/sh

# Stop on errors
set -e

# Check if TOOLBOX_PATH is set
if [ -z "$TOOLBOX_PATH" ]; then
    echo "TOOLBOX_PATH is not set. Setting it to $HOME/.toolbox"
    TOOLBOX_PATH="$HOME/.toolbox"
fi

# Update system package list
sudo apt-get update

# Install Python3, pip, and other utilities
sudo apt-get install -y python3 python3-pip git

# Upgrade pip and install virtualenv
python3 -m pip install --upgrade pip

# Install Ansible
pip install ansible ansible-lint

# Run the playbook
cd ansible
ansible-playbook playbook.yml -vv | tee ansible.log
cd ..

echo "Installation complete!"