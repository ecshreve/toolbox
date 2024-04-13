#!/usr/bin/env bash

# TODO: bake in git clone here

export TOOLBOX_DIR=$PWD
export ANSIBLE_CONFIG=$TOOLBOX_DIR/ansible/ansible.cfg

# check if ansible installed
if [ -z "$(which ansible)" ]; then
    echo "Ansible is not installed. Installing Ansible..."
    sudo add-apt-repository ppa:ansible/ansible
    sudo apt-get update -y && sudo apt-get install -y ansible ansible-lint
else
    echo "Ansible is already installed. Proceeding..."
    echo $TOOLBOX_DIR
    echo $ANSIBLE_CONFIG
fi

cd $TOOLBOX_DIR
ansible-playbook site.yml -vv --check
sudo chsh -s /usr/bin/zsh $USER

