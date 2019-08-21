#!/usr/bin/env zsh

# mainly for debugging load times
if [ ! -z "${ZLOGIN}" ]; then
    source "${ZDOTDIR}/.zlogin"
fi

# load extra dotfiles
for file in ${ZDOTDIR}/env/*.zsh; do
    source "${file}"
done

eval "$(direnv hook zsh)"
