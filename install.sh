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

# Check if ansible-playbook command is available
if ! command -v ansible-playbook &> /dev/null; then
    echo "ansible-playbook command not found. Installing ansible."
    sudo apt update
    sudo apt install -y python3 python3-pip
    pip3 install --user ansible ansible-lint

    # Double check if ansible-playbook command is available
    if ! command -v ansible-playbook &> /dev/null; then
        echo "ansible-playbook command still not found. Exiting."
        exit 1
    fi
fi

# Run the playbook
ansible-playbook playbook.yml --tags stable -vv | tee ansible/logs/install.log

echo "Installation complete!"