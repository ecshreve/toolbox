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

ARG USER=dev
RUN useradd ${USER} \
    --create-home \
    --shell=/bin/bash \
    --uid=1000 \
    --user-group && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER $USER
RUN mkdir -p /home/$USER/.toolbox
WORKDIR /home/$USER/.toolbox

COPY . .

ENV TOOLBOX_DOCKER_BUILD=true

RUN ./install.sh

ENTRYPOINT [ "/bin/bash" ]


