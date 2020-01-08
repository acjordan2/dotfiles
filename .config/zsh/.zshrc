#!/usr/bin/env zsh

declare -a plugins

# order matters
plugins=( 
  history \
  homebrew \
  tmux \
  directory \
  gnu-utility \
  grc \
  completions \
  autosuggestions:defer \
  fast-syntax-highlighting:defer \
  history-substring-search:defer \
  fzf:defer \
)

# load ze plugins
source "${ZDOTDIR}/modules/init.zsh"

# load extra dotfiles
for file in "${ZDOTDIR}"/zshrc.d/{aliases,functions,exports,extra}.zsh; do
  if [ -f "${file}" ]; then 
    source "${file}"
  fi
done
