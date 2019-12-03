#!/usr/bin/env zsh

declare -a plugins

# order matters
plugins=( 
  history \
  directory \
  gnu-utility \
  grc \
  tmux \
  completions:defer \
  autosuggestions:defer \
  fast-syntax-highlighting:defer \
  history-substring-search:defer \
)

# load ze plugins
source "${ZDOTDIR}/modules/init.zsh"

# load extra dotfiles
for file in "${ZDOTDIR}"/zshrc.d/{aliases,functions,exports,extra}.zsh; do
  if [ -f "${file}" ]; then 
    source "${file}"
  fi
done
