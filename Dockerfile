FROM ghcr.io/ecshreve/toolbox-base:latest

ARG USER=vscode
RUN mkdir -p /home/${USER}/.toolbox
WORKDIR /home/${USER}/.toolbox

COPY . .

ENV TOOLBOX_PATH=/home/${USER}/.toolbox
ENV ANSIBLE_CONFIG=/home/${USER}/.toolbox/ansible
ENV GOPATH=/usr/local/go
ENV GOROOT=/usr/local/go

RUN ansible-playbook playbook.yml --tags stable -v

WORKDIR /home/${USER}

CMD ["/bin/zsh"]