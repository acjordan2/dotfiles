#!/usr/bin/env zsh

declare -a plugins

# order matters
plugins=( 
  tmux \
  gnu-utility \
  grc \
  history \
  directory \
  completions \
  autosuggestions \
  fast-syntax-highlighting \
  history-substring-search \
)

# load ze plugins
source "${ZDOTDIR}/modules/init.zsh"

# load extra dotfiles
for file in "${ZDOTDIR}"/zshrc.d/{aliases,functions,exports,extra}.zsh; do
  [ -f "${file}" ] && source "${file}"
done

