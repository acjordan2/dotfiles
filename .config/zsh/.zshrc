#!/usr/bin/env zsh

ZSH_THEME="p10k-lean"
ZSH_INSTANT_PROMPT=true
TMUX_AUTOSTART=true
TMUX_SESSION_ID="1"
TMUX_LOG_LEVEL="2"

# order matters
plugins=(
  history
  homebrew
  tmux
  directory
  gnu-utility
  grc
  completions
  fast-syntax-highlighting
  autosuggestions
  history-substring-search
  fzf
  autopair
  openssl
)

# load ze plugins
source "${ZDOTDIR}/modules/init.zsh"

export GOPATH="${HOME}/go"
export PATH="${HOME}/bin:${PATH}:${HOME}/go/bin"

# load extra dotfiles
for file in "${ZDOTDIR}"/zshrc.d/{aliases,functions,exports,extra}.zsh; do
  if [[ -f "${file}" ]]; then
    jit-source "${file}"
  fi
done

export PATH=$(path | awk '!x[$0]++' | tr "\n" ":")
