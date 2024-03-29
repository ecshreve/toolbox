#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
sudo apt update -y

# Install python3 and ansible
sudo apt install \
    python3 \
    python3-pip \
    python3-apt

# Install ansible
python3 -m pip install --upgrade pip
pip install --user ansible ansible-lint

# Install fzf dependencies
sudo apt install \
    git \
    fd-find \
    ripgrep \
    tmux
sudo ln -s /usr/bin/fdfind /usr/bin/fd

# Check fzf installation
if [ -d $HOME/.fzf ]; then
    echo "FZF is already installed. Uninstalling existing FZF..."
    $HOME/.fzf/uninstall
    rm -rf $HOME/.fzf
fi

echo "Installing FZF from git..."
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install


