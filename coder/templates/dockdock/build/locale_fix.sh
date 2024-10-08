#!/bin/sh

set -e

# Set the locale
sudo apt-get update && sudo apt-get install -y locales

sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

>> /etc/environment cat <<EOF
LANG="en_US.UTF-8"
LANGUAGE="en_US:en"
LC_ALL="en_US.UTF-8"
EOF