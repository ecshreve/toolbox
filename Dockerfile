FROM ubuntu:22.04 as base

LABEL org.opencontainers.image.source "https://github.com/ecshreve/toolbox"
LABEL org.opencontainers.image.description "ecshreve development toolbox"

USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    ca-certificates \
    curl \
    git \
    gpg \
    gnupg \
    jq \
    sudo \
    software-properties-common \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Install locales package
RUN apt-get update && apt-get install -y locales

# Uncomment the desired locale to enable it on the system
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen

# Generate locale
RUN locale-gen

# Set the environment variables
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ARG USER=dev
RUN useradd ${USER} \
    --create-home \
    --shell=/usr/bin/zsh \
    --uid=1000 \
    --user-group && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

RUN <<EOT bash
    apt-get update
    apt-get install -y python3-dev python3-pip
    
    python3 -m pip install --upgrade pip
    python3 -m pip install ansible ansible-lint
EOT

USER $USER
WORKDIR /home/$USER
COPY . .toolbox/

ENV TOOLBOX_DIR=/home/$USER/.toolbox
ENV ANSIBLE_CONFIG=$TOOLBOX_DIR/ansible/ansible.cfg
WORKDIR /home/$USER/.toolbox
RUN ansible-playbook playbook.yml --tags base -v

FROM base as dev

USER $USER
WORKDIR /home/$USER
CMD [ "/bin/bash" ]


