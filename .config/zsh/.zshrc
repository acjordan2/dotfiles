#!/usr/bin/env zsh

ZSH_THEME="p10k-lean"
ZSH_INSTANT_PROMPT=true
TMUX_AUTOSTART=false
TMUX_SESSION_ID="${KITTY_WINDOW_ID}"

# order matters
plugins=( 
  history
  homebrew
  tmux
  directory
  gnu-utility
  grc
  completions
  autosuggestions:defer
  fast-syntax-highlighting:defer
  history-substring-search:defer
  fzf:defer
  autopair:defer
)

# load ze plugins
source "${ZDOTDIR}/modules/init.zsh"

# load extra dotfiles
for file in "${ZDOTDIR}"/zshrc.d/{aliases,functions,exports,extra}.zsh; do
  [[ -f "${file}" ]] && jit-source "${file}"
done
