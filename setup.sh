#!/usr/bin/env bash

export DEBIAN_FRONTEND="noninteractive"

export TOOLBOX_DIR="$(pwd)"
export ANSIBLE_CONFIG="$(which ansible)"
export PATH="/opt/homebrew/bin:$PATH"  # Add Homebrew to PATH

# Install Homebrew if not already installed
if [ -z "$(which brew)" ]; then
    echo "Installing Homebrew..."
    echo "Exiting..."
    exit 1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

export PATH="/Users/eric/Library/Python/3.9/bin:$PATH"
# Install Ansible using the system Python
if [ -z "$(which ansible)" ]; then
    echo "Installing Ansible..."
    echo "Exiting..."
    exit 1
    python3 -m pip install --upgrade pip --user
    python3 -m pip install ansible ansible-lint --user
fi

echo "Done setting up the environment."
echo "Ready for Ansible playbook execution."