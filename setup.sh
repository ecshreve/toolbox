#!/usr/bin/env bash

set -x

export DEBIAN_FRONTEND="noninteractive"

export TOOLBOX_DIR=$HOME/github/ecshreve/toolbox
export ANSIBLE_CONFIG=$TOOLBOX_DIR/ansible/ansible.cfg

export PATH="/opt/homebrew/bin:$PATH"  # Add Homebrew to PATH

# Install Homebrew if not already installed
if [ -z "$(which brew)" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

export PATH="/Users/eric/Library/Python/3.9/bin/:$PATH"
# Install Ansible using the system Python
if [ -z "$(which ansible)" ]; then
    python3 -m pip install --upgrade pip --user
    python3 -m pip install ansible ansible-lint --user
fi

ansible-playbook playbook.yml --tags base -v

echo "Done."