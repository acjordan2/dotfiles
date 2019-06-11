#!/usr/bin/env zsh

# replace system tools with gnutils, e.g. cp, mv, etc
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/bin"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

source "$XDG_CONFIG_HOME/zsh/env/exports"

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
for file in $ZSH_CONFIG/env/{extra,aliases,functions,plugins,history}; do
    [ -r "${file}" ] && source "${file}"
done

# Generic colouriser
if grc >/dev/null 2>&1; then
  source /usr/local/etc/grc.bashrc 2>/dev/null
fi

# emacs bindings 
bindkey -e

# ZSH options
setopt noautoremoveslash    # keep the slash when resolving symlinks 
setopt auto_cd              # auto CD into path 

# Add new line before rending prompt 
precmd() { print "" } 

# {green}$user@$host{/green} {orange}λ{/orange} {blue}$PWD{/blue}
PROMPT=$'%F{113}%n@%m%f %F{208}λ%f %F{6}%~\n'

# ❯❯❯
PROMPT="${PROMPT}%B%F{1}❯%F{3}❯%F{2}❯%f%b "

# Change auto complete colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Case insensitive tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

## ignores filenames already in the line
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes

## Ignore completion functions for commands you don't have:
zstyle ':completion:*:functions' ignored-patterns '_*'

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

eval "$(direnv hook zsh)"

