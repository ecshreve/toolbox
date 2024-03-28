#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

# Update the package list and install Zsh
sudo apt update -y
sudo apt install zsh

# Check zsh version
zsh --version

# Check if Oh My Zsh is installed
if [ ! -d ~/.oh-my-zsh ]; then
    echo "Oh My Zsh is not installed. Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Backup the default .zshrc file
mv ~/.zshrc ~/.zshrc.bak

# Copy the custom .zshrc file
cp .zshrc ~/.zshrc

# Change the default shell to Zsh
chsh -s $(which zsh)

