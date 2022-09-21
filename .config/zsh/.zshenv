#!/usr/bin/env zsh

# Path Stuff
export PATH="${HOME}/.cargo/bin:${PATH}"

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# neovim as default editor
export EDITOR="${HOME}/bin/editor"
export VISUAL="${EDITOR}"
. "$HOME/.cargo/env"
