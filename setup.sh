#!/usr/bin/env bash

export DEBIAN_FRONTEND="noninteractive"

# This should be ~/repos/toolbox but maybe not
export TOOLBOX_DIR="$(pwd)"


PYTHON_LOCATION="$(which python3)"

# Check for package manager to determine operating system
# to install python3 and pip
if [ -z "$(which apt-get)" ]; then
    echo "Detected package manager: apt-get"
    echo "Updating package list..."
    sudo apt-get update

    # Install python3 and pip
    echo "Installing required packages..."
    sudo apt-get install -y python3 python3-pip
elif [ -z "$(which brew)" ]; then
    echo "Detected package manager: Homebrew"
    echo "EXITING"
    exit 1

    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    export PATH="/opt/homebrew/bin:$PATH"  # Add Homebrew to PATH
    PYTHON_LOCATION="/Users/eric/Library/Python/3.9/bin"
fi
export PATH=:$PATH:$PYTHON_LOCATION

# Install Ansible using pip
if [ -z "$(which ansible)" ]; then
    echo "Installing Ansible..."
    $PYTHON_LOCATION/python3 -m pip install ansible ansible-lint --user
     -m pip install --upgrade pip --user
    $PYTHON_LOCATION/python3 -m pip install ansible ansible-lint --user
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
ansible-playbook $PLAYBOOK --check