#!/usr/bin/env bash

config="$HOME/.config"
data="$HOME/.local/share"
cache="$HOME/.cache"


dirs=("${config}" "${data}" "${cache}")
extra_dirs=("zsh" "tmux" "nvim")

for i in "${dirs[@]}"; do
    if [ "${i}" != "${config}" ]; then
       for k in "${extra_dirs[@]}"; do
            mkdir -v -p "${i}/${k}"
       done
    else 
            mkdir -v -p "${i}"
    fi
done
