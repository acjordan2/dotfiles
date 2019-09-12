#!/usr/bin/env zsh

# Path Stuff
export PATH="${PATH}:${HOME}/bin"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# neovim as default editor
export EDITOR="vim"
export VISUAL="$EDITOR"
