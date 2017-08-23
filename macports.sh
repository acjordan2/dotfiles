#!/usr/bin/env bash

sudo port selfupdate
sudo port upgrade outdated
sudo port install \ 
    binutils \
    coreutils \
    ctags \
    go \
    grep \
    gsed \
    nmap \
    the_silver_searcher \
    tmux \
    tmux-pasteboard \
    vim \
    zsh 
