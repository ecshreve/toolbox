#!/usr/bin/env bash

# func to check for ansible
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
check_ansible

# run local playbook
ansible-playbook ansible/local.yml -vv





