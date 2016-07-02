#!/bin/bash

files=("$(pwd)/vim/vim" "$(pwd)/vim/vimrc")
files_r=(~/.vim ~/.vimrc)
count=0

for file in "${files_r[@]}"
do
    if [ -L $file ]; then
        rm $file
        echo "Removing symlink to $file"
    elif [ -f $file ]; then
        echo "Backing up existing vim files"
        if [ -f $file.bak ]; then
            echo "$file.bak already exists"
        else
            echo "Moving $file to $file.bak"
            mv $file $file.bak
        fi
    fi
    echo "Creating symlink to ${files[$count]}"
    ln -s ${files[$count]} $file
    count=$((count+1))
done;

mkdir ~/.vim/swapfiles
mkdir ~/.vim/vimundo

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

mkdir ~/.vim/fonts
git clone https://github.com/powerline/fonts ~/.vim/fonts
cd ~/.vim/fonts
./install.sh
