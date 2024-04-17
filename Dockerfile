FROM --platform=linux/amd64 ubuntu:22.04 as build

LABEL org.opencontainers.image.source="https://github.com/ecshreve/toolbox"

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
    zsh \
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

RUN apt-get update && apt-get install -y python3-dev python3-pip
RUN python3 -m pip install --upgrade pip && python3 -m pip install ansible

USER $USER
WORKDIR /home/$USER
COPY --chown=${USER}:${USER} . .toolbox/

ENV TOOLBOX_DIR=/home/$USER/.toolbox
ENV ANSIBLE_HOME=$TOOLBOX_DIR/ansible

FROM build as base
RUN ansible-playbook $TOOLBOX_DIR/playbook.yml --tags base -v

FROM base as golang
RUN ansible-playbook $TOOLBOX_DIR/playbook.yml --tags golang -v

CMD [ "/bin/bash" ]


