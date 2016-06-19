#!/bin/sh

ln -s $(pwd)/vim ~/.vim
ln -s $(pwd)/vimrc ~/.vimrc

mkdir ~/.vim/swapfiles

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
