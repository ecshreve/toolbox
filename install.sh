#!/usr/bin/env bash
# This script installs Ansible and runs the playbook to configure the system.
# Intended for fresh Ubuntu 22.04 installation. For updates or MacOS, better to
# use the playbook or roles directly.

set -euo pipefail      # Exit on error, undefined variable, or pipe failure

# Initialize default values
INSTALL_CHECK_MODE=true
ANSIBLE_FLAGS="-vv"  # Default ansible-playbook flags

# Function Definitions

display_help() {
    cat << EOF
Usage: ./install.sh [OPTIONS]

Installs Ansible and runs playbook for system configuration, primarily for
Ubuntu 22.04.

Options:
  --help                Display this help message and exit.
  --apply-install       Apply changes instead of running in check mode.
  --ansible-flags       Specify custom ansible-playbook flags. Default "-vv".

Environment Variables:
  TOOLBOX_PATH          Path for toolbox installation. Defaults to "\$HOME/.toolbox".

Examples:
  1. Run script in check mode with default verbose flags (-vv):
     ./install.sh

  2. Apply changes (disable check mode):
     ./install.sh --apply-install

  3. Specify custom Ansible flags for playbook execution:
     ./install.sh --ansible-flags="-v --tags mytag"

Description:
Checks and installs Ansible if not found. Runs an Ansible playbook, customizable
through command-line options to apply configurations or preview changes.

Requires sudo permissions for installing packages and running playbooks.
EOF
    exit 0
}

check_prerequisites() {
    if ! command -v sudo &> /dev/null; then
        echo "sudo command not found. Ensure permissions to run this script."
        exit 1
    fi
}

setup_toolbox_path() {
    # TODO: this is brittle, needs thought.
    if [ -z "${TOOLBOX_PATH:-}" ]; then
        echo "TOOLBOX_PATH not set. Setting to \$HOME/.toolbox"
        TOOLBOX_PATH="\$HOME/.toolbox"
        mkdir -p "$TOOLBOX_PATH"
    fi
}

install_ansible() {
    if ! command -v ansible-playbook &> /dev/null; then
        echo "ansible-playbook command not found. Installing Ansible."
        sudo apt update
        sudo apt install -y python3 python3-pip
        pip3 install --user ansible ansible-lint

        if ! command -v ansible-playbook &> /dev/null; then
            echo "ansible-playbook not found after installation. Exiting."
            exit 1
        fi
    fi
}

run_playbook() {
    mkdir -p ansible/logs

    if [ "$INSTALL_CHECK_MODE" = true ]; then
        ANSIBLE_FLAGS+=" --check"
        echo "Running in check mode. No changes will be made."
        echo "Use --apply-install to apply changes."
        echo "Continue? [y/N]"
        read -r response
        if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo "Exiting."
            exit 0
        fi
    else
        echo "Applying changes."
    fi

    echo "Running playbook with flags: ${ANSIBLE_FLAGS}" | tee ansible/logs/install.log
    ansible-playbook playbook.yml ${ANSIBLE_FLAGS} | \
    tee ansible/logs/install.log

    echo "Installation complete!"

    if [ "$INSTALL_CHECK_MODE" = true ]; then
        echo "!!!"
        echo "No changes made. Use --apply-install to apply changes."
    fi
}

# Parse Command-Line Arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --apply-install)
            INSTALL_CHECK_MODE=false
            shift
            ;;
        --ansible-flags)
            ANSIBLE_FLAGS=$2
            shift 2
            ;;
        --help)
            display_help
            ;;
        *)
            echo "Unknown option: $1"
            display_help
            ;;
    esac
done

check_prerequisites
setup_toolbox_path
install_ansible
run_playbook
