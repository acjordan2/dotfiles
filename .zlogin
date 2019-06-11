#!/usr/bin/env zsh

source $ZSH_CONFIG/env/history
source $ZSH_CONFIG/env/plugins

# start in tmux session first
if command tmux -V >/dev/null 2>&1; then
  if [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then 
    TMUX_LOG_DIR="$XDG_DATA_HOME/tmux/log"
    TMUX_SESSION_ID="$(echo "$TERM_SESSION_ID" | cut -d ":" -f1)"
    cd "${TMUX_LOG_DIR}" || { mkdir -p "${TMUX_LOG_DIR}" && cd "${TMUX_LOG_DIR}" }
    TERM=xterm-256color; tmux new-session -A -s "${TMUX_SESSION_ID}" -c "$HOME"
    exit; 
  fi
else
  echo "tmux is not installed" 1>&2
fi

# Generic colouriser
source /usr/local/etc/grc.bashrc 2>/dev/null

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

if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION") ]; then
    compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
else
    compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
fi

# Execute code in the background to not affect the current session
{
  # Compile zcompdump, if modified, to increase startup speed.
  zcompdump="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"  
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!
