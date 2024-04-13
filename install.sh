#!/usr/bin/env bash

# This script was tested on a fresh Ubuntu 22.04 install.
#
# The script clones the toolbox repo and runs the playbook in check mode.

set -euo pipefail

TOOLBOX_REPO="https://github.com/ecshreve/toolbox"
export TOOLBOX_DIR=${TOOLBOX_DIR:-$HOME/.toolbox}
export ANSIBLE_CONFIG=$TOOLBOX_DIR/ansible/ansible.cfg

# check if git is installed
if [ -z "$(which git)" ]; then
    echo "Git is not installed. Please install git."
    exit 1
fi

if [ ! -d $TOOLBOX_DIR ]; then
    echo "Toolbox directory does not exist. Creating..."
    mkdir -p $TOOLBOX_DIR
    git clone $TOOLBOX_REPO $TOOLBOX_DIR
else
    echo "Toolbox directory already exists. Proceeding..."
fi
echo "Toolbox directory: $TOOLBOX_DIR"

# check if ansible installed
if [ -z "$(which ansible)" ]; then
    echo "Ansible is not installed. Installing Ansible..."
    sudo add-apt-repository ppa:ansible/ansible
    sudo apt-get update -y && sudo apt-get install -y ansible ansible-lint
else
    echo "Ansible is already installed. Proceeding..."
fi
echo "Ansible config: $ANSIBLE_CONFIG"

# run the full playbook
echo "Running playbook IN CHECK MODE...edit install.sh to execute for real."

cd $TOOLBOX_DIR
ansible-playbook playbook.yml --tags stable -vv --check
sudo chsh -s /usr/bin/zsh $USER

echo "Done."

