#!/usr/bin/env bash
# This script installs Ansible and runs the playbook to configure the system.
# It is intended to be run on a fresh Ubuntu 22.04 installation.
#
# For updates or MacOS it's better to use the playbook or roles directly.

set -e      # Exit on error

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
ansible-playbook playbook.yml -vv | tee ansible/logs/ansible.log

echo "Installation complete!"