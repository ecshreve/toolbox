FROM mcr.microsoft.com/devcontainers/base:ubuntu

SHELL ["/bin/bash", "-c"]

# Update and install system utilities
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && yes | unminimize 2>&1 

RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get upgrade --yes && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes ca-certificates apt-utils

# Install base packages
RUN apt-get update && \
    apt-get install --yes \
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
      rsync \
      docker.io  # Ensure Docker CLI is installed

# Install Ansible and dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install --yes \
      libssl-dev \
      libffi-dev \
      python3-dev && \
    python3 -m pip install --upgrade pip && \
    pip3 install ansible ansible-lint

# Adjust user permissions to access Docker socket
ARG USER=vscode
RUN usermod -aG docker ${USER}

USER ${USER}
WORKDIR /home/${USER}
