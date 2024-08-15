FROM ubuntu

RUN apt-get update && apt-get install -y \
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

COPY ./locale_fix.sh /tmp/locale_fix.sh
RUN /tmp/locale_fix.sh

ARG USER=coder
RUN useradd --groups sudo --no-create-home --shell /bin/bash ${USER} \
	&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/${USER} \
	&& chmod 0440 /etc/sudoers.d/${USER}

USER ${USER}
WORKDIR /home/${USER}