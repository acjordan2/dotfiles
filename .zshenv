#!/usr/bin/env zsh
# XDG Base dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# ZSH dirs
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
source "${ZDOTDIR}/.zshenv"
