#!/bin/bash

sudo purt selfupdate
sudo port upgrade outdated
sudo port install \ 
    nmap \
    vim \
    ctags \
    coreutils \
    binutils \
    grep \
    tmux \
    zsh \
    go
