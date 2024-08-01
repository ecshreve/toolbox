#!/usr/bin/env bash

export DEBIAN_FRONTEND="noninteractive"

# This should be ~/repos/toolbox but maybe not
export TOOLBOX_DIR="$(pwd)"

OS_ID=""
PYTHON_LOCATION="$(which python3)"
# Check for package manager to determine operating system
# to install python3 and pip
if [ -n "$(which apt-get)" ]; then
    echo "Detected package manager: apt-get"
    echo "Updating package list..."
    OS_ID="debian"
    sudo apt-get update

    # Install python3 and pip
    echo "Installing required packages..."
    sudo apt-get install -y python3-full python3-pip python3-apt

# !FIX
elif [ -n "$(which brew)" ]; then
    echo "Detected package manager: Homebrew"
    OS_ID="darwin"
    echo "EXITING"
    exit 1
fi
if [ -z $OS_ID ]; then
    echo "Can't determine OS, exiting"
    exit 1
fi
export PATH=:$PATH:$PYTHON_LOCATION

export PATH=:$PATH:$PYTHON_LOCATION
mkdir -p $HOME/.local/bin
export PATH=$PATH:$HOME/.local/bin

# Install Ansible using pip
if [ -z "$(which ansible)" ]; then
    echo "Creating venv for ansible"
    python3 -m venv ansible-venv
    source ansible-venv/bin/activate

    echo "Installing Ansible with pip..."
    pip install ansible 
fi
export ANSIBLE_CONFIG="$TOOLBOX_DIR/ansible/ansible.cfg"

echo "Done setting up the environment."
echo "Ready for Ansible playbook execution."

# Execute Ansible playbook
# Example usage: ./setup.sh playbook.yml
PLAYBOOK=$1
if [ -z "$1" ]; then
    echo "No playbook specified. Executing default playbook."
    PLAYBOOK="$TOOLBOX_DIR/ansible/playbook.yml"
fi


echo "Executing Ansible playbook: $PLAYBOOK"
ansible-playbook $PLAYBOOK --tags stable,base -vv 