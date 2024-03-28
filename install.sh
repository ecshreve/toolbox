#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
sudo apt update -y

# Install python3 and ansible
sudo apt install python3 python3-pip python3-apt
python3 -m pip install --upgrade pip
pip install --user ansible ansible-lint

# Install fzf dependencies
sudo apt install fd-find ripgrep tmux
sudo ln -s /usr/bin/fdfind /usr/bin/fd

# Check fzf installation
if [ ! -d ~/.fzf ]; then
    echo "FZF is not installed. Installing FZF..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
else
    echo "FZF is already installed. Skipping..."
fi


