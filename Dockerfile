FROM ubuntu:22.04 AS base_ubu

SHELL ["/bin/bash", "-c"]

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    # Restore man command
    && yes | unminimize 2>&1 

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get upgrade --yes && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes ca-certificates apt-utils

# Install base packages
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
      bash \
      build-essential \
      curl \
      gnupg \
      htop \
      locales \
      man \
      netbase \
      python3 \
      python3-pip \
      software-properties-common \
      sudo \
      systemd \
      systemd-sysv \
      unzip \
      vim \
      wget \
      rsync && \
    # Install latest Git using their official PPA
    add-apt-repository ppa:git-core/ppa && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes git

# Make typing unicode characters in the terminal work.
ENV LANG en_US.UTF-8

FROM base_ubu AS docker_ubu

# Install Docker
RUN apt-get update && \
    # Install required packages
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
      apt-transport-https \
      ca-certificates \
      curl \
      gnupg \
      lsb-release && \
    # Add Docker apt repository
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list && \
    # Install Packages
    apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes docker-ce docker-ce-cli containerd.io
   

FROM docker_ubu AS ansible_ubu

# Install Ansible dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
      libssl-dev \
      libffi-dev \
      python3-dev

# Install Ansible
RUN python3 -m pip install --upgrade pip && \
pip3 install ansible ansible-lint

LABEL devcontainer.metadata='[{ \
  "remoteUser": "dev", \ 
}]'
