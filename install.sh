#!/usr/bin/env bash

# This script assumes it is being run from the root of the toolbox repo, which 
# must match the dotfiles_toolbox_dir variable in the dotfiles ansible role. It 
# defaults to ~/github.com/ecshreve/toolbox directory.

set -e

# check_ansible() checks for python3, ansible-venv, and ansible.
check_ansible() {
    # check for python3
    if ! command -v python3 &> /dev/null; then
        echo "Python3 is not installed, exiting..."
        exit 1
    fi

    # check for ansible-venv dir
    if [ ! -d "ansible-venv" ]; then
        echo "Ansible venv does not exist, creating..."
        python3 -m venv ansible-venv
    fi

    # activate the venv
    source ansible-venv/bin/activate

    # check for ansible
    if ! command -v ansible &> /dev/null; then
        echo "Ansible is not installed, installing..."
        python3 -m pip install ansible
    fi

    PYTHON_VER=$(python3 --version)
    ANSIBLE_VER=$(ansible --version | head -n 1)
    echo "Python version: $PYTHON_VER"
    echo "Ansible version: $ANSIBLE_VER"
}

echo "Checking for ansible and python3..."
check_ansible

# If the first argument is --dry, run the playbook in check (dry-run) mode.
PLAYBOOK_ARGS="-v"
if [ "$1" == "--dry" ]; then
    PLAYBOOK_ARGS="$PLAYBOOK_ARGS --check"
    echo "Running in check (dry-run) mode..."
fi

echo "Running playbook..."
export ANSIBLE_CONFIG="$PWD/ansible/ansible.cfg"
ansible-playbook ansible/localhost-playbook.yml $PLAYBOOK_ARGS





