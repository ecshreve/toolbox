FROM mcr.microsoft.com/devcontainers/base:ubuntu as build

SHELL ["/bin/bash", "-c"]

RUN apt-get update && export DEBIAN_FRONTEND="noninteractive" \
    && apt-get upgrade --yes \
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

# Adjust user permissions to access Docker socket
ARG USER=vscode
RUN usermod -aG docker ${USER}

FROM build as base

ARG USER=vscode
RUN mkdir -p /home/${USER}/.toolbox
WORKDIR /home/${USER}/.toolbox

COPY . .

ENV TOOLBOX_PATH=/home/${USER}/.toolbox
ENV ANSIBLE_CONFIG=/home/${USER}/.toolbox/ansible

RUN ansible-playbook playbook.yml --tags base -v

FROM base as dev

ARG USER=vscode
RUN ansible-playbook playbook.yml --tags dev -v

WORKDIR /home/${USER}
CMD ["/bin/zsh"]