#!/usr/bin/env bash

echo "[Warning] install packages from homebrew/Macports before continuing"
echo "Starting in 10 seconds"
sleep 10

source ./setup-symlink.sh

vim +PlugInstall

# Install powerline fonts
cd "$HOME/.vim/fonts" || return
./install.sh
