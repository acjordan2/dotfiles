#!/usr/bin/env zsh

# start in tmux session first
if [ ! "$(tmux -V 2>/dev/null)" ] ; then
  echo "tmux is not installed"
else
    name="$(echo "$TERM_SESSION_ID" | cut -d ":" -f1)"
    if [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then 
      TERM=xterm-256color; { tmux attach -t "${name}" ||  tmux new-session -A -s "${name}" };
      exit; 
    fi
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
if [ "$(grc 2>/dev/null)" ]; then
  source /usr/local/etc/grc.bashrc 2>/dev/null
fi

# Change auto complete colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
autoload -Uz compinit
compinit

# source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
eval "$(direnv hook zsh)"
