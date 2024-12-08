#!/usr/bin/env bash

export DEBIAN_FRONTEND="noninteractive"
export TOOLBOX_DIR="$(pwd)"

OS_ID=""

# Check for package manager to determine operating system
# to install python3 and pip
if [ -n "$(which apt-get)" ]; then
    echo "Detected package manager: apt-get"
    echo "Updating package list..."
    OS_ID="debian"
    sudo DEBIAN_FRONTEND=noninteractive apt-get update

    # Install python3 and pip
    echo "Installing required packages..."
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y python3-full python3-pip python3-apt python3-venv

elif [ -n "$(which port)" ]; then
    echo "Detected package manager: MacPorts"
    OS_ID="darwin"
fi

# If neither apt-get nor brew is found, exit with an error message
if [ -z $OS_ID ]; then
    echo "Can't determine OS, exiting"
    exit 1
fi

# Check for python3 and pip
if [ -z "$(which python3)" ]; then
    echo "Python3 not found, exiting"
    exit 1
fi

# Check for ansible-venv and create it if it doesn't exist
if [ ! -d "ansible-venv" ]; then
    echo "Creating venv for ansible"
    python3 -m venv ansible-venv
fi

# Activate the venv
source ansible-venv/bin/activate

# Install ansible
echo "Installing Ansible with pip..."
pip install ansible


echo "Ready for Ansible playbook execution."
export ANSIBLE_CONFIG="$TOOLBOX_DIR/ansible/ansible.cfg"
PLAYBOOK=$TOOLBOX_DIR/ansible/playbook.yml

echo "Executing Ansible playbook: $PLAYBOOK"
ansible-playbook $PLAYBOOK --tags stable -vvv
