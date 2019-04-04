#!/usr/bin/env zsh

# start in tmux session first
if command tmux -V >/dev/null 2>&1; then
  TMUX_SESSION_ID="$(echo "$TERM_SESSION_ID" | cut -d ":" -f1)"
  if [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then 
    TERM=xterm-256color; tmux new-session -A -s "${TMUX_SESSION_ID}"
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
