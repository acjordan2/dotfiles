#!/bin/bash

source ./setup-symlink.sh

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall

mkdir ~/.vim/fonts
git clone https://github.com/powerline/fonts ~/.vim/fonts
cd ~/.vim/fonts
./install.sh
