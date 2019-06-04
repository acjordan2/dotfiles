#!/usr/bin/env zsh

export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export ZSH_CONFIG="$XDG_CONFIG_HOME/zsh"
export ZSH_LOG="$XDG_DATA_HOME/zsh"

source "$ZSH_CONFIG/env/path"

# start in tmux session first
if command tmux -V >/dev/null 2>&1; then
  TMUX_LOG_DIR="$XDG_DATA_HOME/tmux/log"
  TMUX_SESSION_ID="$(echo "$TERM_SESSION_ID" | cut -d ":" -f1)"
  if [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then 
    cd "${TMUX_LOG_DIR}" || { mkdir -p "${TMUX_LOG_DIR}" && cd "${TMUX_LOG_DIR}" }
    TERM=xterm-256color; tmux new-session -A -s "${TMUX_SESSION_ID}" -c "$HOME"
    exit; 
  fi
else
  echo "tmux is not installed" 1>&2
fi

# load extra dotfiles
for file in $ZSH_CONFIG/env/{extra,bash_prompt,exports,aliases,functions,plugins,history}; do
    [ -r "${file}" ] && source "${file}"
done

# Generic colouriser
if grc >/dev/null 2>&1; then
  source /usr/local/etc/grc.bashrc 2>/dev/null
fi

## Theme configs
precmd() { print "" } # Add new line before rending pmrot
PROMPT=$'%F{113}%n@%m%f %F{208}λ%f %F{6}%~\n%B%F{1}❯%F{3}❯%F{2}❯%f%b '

# Change auto complete colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
autoload -Uz compinit
compinit

eval "$(direnv hook zsh)"

# shortcuts
bindkey -e
