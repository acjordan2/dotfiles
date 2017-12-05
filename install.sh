#!/usr/bin/env bash

echo "[Warning] install packages from homebrew/Macports before continuing"
echo "Starting in 10 seconds"
sleep 10

source ./setup-symlink.sh

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall

# Install powerline fonts
mkdir ~/.vim/fonts
git clone https://github.com/powerline/fonts ~/.vim/fonts
cd ~/.vim/fonts
./install.sh

# Uninstall oh_my_zsh if it exists
if [ -n "($type -t uninstall_oh_my_zsh)" ] && [ "$(type -t uninstall_oh_my_zsh)" = function ]; then
  uninstall_oh_my_zsh
fi

# Install prezto
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
ln -s "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/.zlogin" ${ZDOTDIR:-$HOME}"/.zlogin

# Symlink customized prezto settings and themes
find .zprezto -type f -exec ln -s $PWD/{} ~/{} \;
