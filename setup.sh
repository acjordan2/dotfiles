#!/usr/bin/env bash

echo "[Warning] install packages from homebrew/Macports before continuing"
echo "Starting in 10 seconds"
sleep 10

source ./setup-symlink.sh

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall

mkdir ~/.vim/fonts
git clone https://github.com/powerline/fonts ~/.vim/fonts
cd ~/.vim/fonts
./install.sh
cd ~/.vim/plugged/YouCompleteMe/
./install.py --clang-completer --gocode-completer --racer-completer

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
