#!/usr/bin/env zsh
# load extra dotfiles
for file in $ZSH_CONFIG/env/{extra,aliases,functions}; do
    [ -r "${file}" ] && source "${file}"
done

eval "$(direnv hook zsh)"
