#!/usr/bin/env zsh

source "$HOME/.path"

# start in tmux session first
if command tmux -V >/dev/null 2>&1; then
  TMUX_LOG_DIR="$XDG_DATA_HOME/tmux/log"
  TMUX_SESSION_ID="$(echo "$TERM_SESSION_ID" | cut -d ":" -f1)"
  if [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then 
      if [ ! -d "${TMUX_LOG_DIR}" ]; then
        mkdir -p "${TMUX_LOG_DIR}"
    fi
    cd "${TMUX_LOG_DIR}"
    TERM=xterm-256color; tmux new-session -A -s "${TMUX_SESSION_ID}" -c "$HOME"
    exit; 
  fi
else
  echo "tmux is not installed" 1>&2
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# load extra dotfiles
for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
    [ -r "${file}" ] && source "${file}"
done

# Generic colouriser
if grc >/dev/null 2>&1; then
  source /usr/local/etc/grc.bashrc 2>/dev/null
fi

# Change auto complete colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
autoload -Uz compinit
compinit

# source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
eval "$(direnv hook zsh)"
