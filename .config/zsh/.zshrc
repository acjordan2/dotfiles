#!/usr/bin/env zsh

declare -a plugins

# order matters
plugins=( 
          homebrew \
          tmux \
          autosuggestions \
          directory \
          fast-syntax-highlighting \
          grc \
          history \
          history-substring-search \
        )

# load ze plugins
source "${ZDOTDIR}/modules/init.zsh"

# load extra dotfiles
for file in "${ZDOTDIR}"/zshrc.d/{aliases,functions,exports,extra}.zsh; do
  source "${file}"
done
