#!/usr/bin/env bash

set -x

export DEBIAN_FRONTEND="noninteractive"

export TOOLBOX_DIR=$(pwd)
export ANSIBLE_CONFIG=$TOOLBOX_DIR/ansible/ansible.cfg

sudo apt-get update && sudo apt-get install -y python3-dev python3-pip

if [ -z "$(which ansible)" ]; then
        python3 -m pip install --upgrade pip
        python3 -m pip install ansible
        export PATH=$PATH:$HOME/.local/bin
fi

ansible-playbook playbook.yml --tags base -v

echo "Done."