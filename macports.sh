#!/bin/bash

sudo port selfupdate
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
    go \
    the_silver_searcher
