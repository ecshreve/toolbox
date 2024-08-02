FROM ubuntu:24.04

RUN apt-get update \
	&& apt-get install -y \
	curl \
	git \
	golang \
	sudo \
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

RUN apt-get update && apt-get install -y \
	python3-full \
	python3-pip \
	python3-apt \
	&& rm -rf /var/lib/apt/lists/*

ARG USER=coder
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}
USER ${USER}
WORKDIR /home/${USER}