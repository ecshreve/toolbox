FROM ubuntu

RUN apt-get update && apt-get install -y \
	curl \
	git \
	golang \
	sudo \
	vim \
	wget \
	ca-certificates \
	gnupg \
	apt-transport-https \
    software-properties-common \
	systemd \
	systemd-sysv \
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

COPY ./locale_fix.sh /tmp/locale_fix.sh
RUN /tmp/locale_fix.sh

COPY ./docker_install.sh /tmp/docker_install.sh
RUN /tmp/docker_install.sh

RUN systemctl enable docker

ARG USER=coder
RUN useradd --groups sudo,docker --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}

USER ${USER}
WORKDIR /home/${USER}