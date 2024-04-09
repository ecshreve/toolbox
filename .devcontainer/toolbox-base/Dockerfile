FROM mcr.microsoft.com/devcontainers/base:ubuntu as toolbox-base

SHELL ["/bin/bash", "-c"]

RUN apt-get update && export DEBIAN_FRONTEND="noninteractive" \
    && apt-get install --no-install-recommends --yes \
      apt-utils \
      bash \
      build-essential \
      ca-certificates \
      curl \
      gnupg \
      htop \
      libssl-dev \
      libffi-dev \
      locales \
      man \
      netbase \
      python3 \
      python3-pip \
      python3-dev \
      software-properties-common \
      sudo \
      systemd \
      systemd-sysv \
      unzip \
      vim \
      wget \
      rsync \
      docker.io \
      && rm -rf /var/lib/apt/lists/*

# Install Ansible and dependencies
RUN python3 -m pip install --upgrade pip && \
    pip3 install ansible ansible-lint

FROM toolbox-base as toolbox-user

# Adjust user permissions to access Docker socket
ARG USER=vscode
RUN usermod -aG docker ${USER}

USER ${USER}
RUN mkdir -p /home/${USER}/.toolbox
WORKDIR /home/${USER}/.toolbox
COPY --chown=${USER} . .

# Run ansible playbook for shell setup
ENV TOOLBOX_PATH=/home/${USER}/.toolbox
ENV ANSIBLE_CONFIG=${TOOLBOX_PATH}/ansible/ansible.cfg
RUN ansible-playbook playbook.yml --tags base -v

# Set the default shell to bash
SHELL ["/bin/bash", "-c"]

WORKDIR /home/${USER}


