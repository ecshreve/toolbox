FROM ubuntu:22.04 as devbase

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

USER $USER
RUN mkdir -p /home/$USER/.toolbox
WORKDIR /home/$USER/.toolbox

COPY . .

ENV TOOLBOX_DOCKER_BUILD=true

RUN ./install.sh

CMD [ "/bin/bash" ]


