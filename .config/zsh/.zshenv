#!/usr/bin/env zsh
# replace system tools with gnutils, e.g. cp, mv, etc
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_LOG="$XDG_DATA_HOME/zsh"

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# neovim as default editor
export EDITOR="nvim"
export VISUAL="$EDITOR"
