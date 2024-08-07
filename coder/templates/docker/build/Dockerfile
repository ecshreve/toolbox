FROM ubuntu:24.04

USER root

RUN apt-get update && apt-get install -y \
	apt-transport-https \
	build-essential \
	ca-certificates \
	curl \
	git \
	gnupg \
	gpg \
	lsb-release \
	nano \
	openssh-client \
	rsync \
	sudo \
	unzip \
	vim \
	wget \
	&& rm -rf /var/lib/apt/lists/*

# cli tools
RUN apt-get update && apt-get install -y \
	apt-utils \
	bat \
	eza \
	fd-find \
	htop \
	net-tools \
	prettyping \
	ripgrep \
	&& rm -rf /var/lib/apt/lists/*

# install python
RUN apt-get update && apt-get install -y \
	python3-full \
	python3-pip \
	python3-apt \
	&& rm -rf /var/lib/apt/lists/*

COPY locale_setup.sh /tmp/
RUN /tmp/locale_setup.sh

COPY docker_setup.sh /tmp/
RUN /tmp/docker_setup.sh



ARG USER=coder
RUN useradd ${USER} \
		--create-home \
		--shell=/bin/bash \
		--groups=docker,sudo \
		--uid=1001 \
		--user-group && \
	echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

USER ${USER}
WORKDIR /home/${USER}