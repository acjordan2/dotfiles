#!/usr/bin/env zsh
#
# start in tmux session first
if command tmux -V >/dev/null 2>&1; then
  if [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then 
    TMUX_LOG_DIR="$XDG_DATA_HOME/tmux/log"
    TMUX_SESSION_ID="$(echo "${TERM_SESSION_ID:-${KITTY_WINDOW_ID}}" | cut -d ":" -f1)"
    cd "${TMUX_LOG_DIR}" || { mkdir -p "${TMUX_LOG_DIR}" && cd "${TMUX_LOG_DIR}" }
    { TERM=xterm-256color; tmux -f "${XDG_CONFIG_HOME}/.tmux.conf" new-session -A -s "${TMUX_SESSION_ID}" -c "$HOME" } && exit
  fi
else
  echo "tmux is not installed" 1>&2
fi

for file in ${ZDOTDIR}/env/*.zlogin; do
  source "${file}"
done

autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION" 2>/dev/null) ]; then
    compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-${ZSH_VERSION}"

    # make sure this check only happens once a day
    touch "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"
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
