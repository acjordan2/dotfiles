#!/usr/bin/env zsh

theme="p10k-lean"

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

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [ -n "${TMUX}" ]; then
  if [[ "${theme}" == 'powerlevel10k' ]] || [[ "${theme}" == "p10k"* ]]; then
    if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
      source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
    fi
  fi
fi

# load ze plugins
source "${ZDOTDIR}/modules/init.zsh"

# load extra dotfiles
for file in "${ZDOTDIR}"/zshrc.d/{aliases,functions,exports,extra}.zsh; do
  if [ -f "${file}" ]; then 
    source "${file}"
  fi
done
