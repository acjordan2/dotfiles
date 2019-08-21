#!/usr/bin/env zsh

source "${ZDOTDIR}/env/plugins.zlogin"
source "${ZDOTDIR}/env/options.zlogin"

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

# Generic colouriser
source /usr/local/etc/grc.zsh 2>/dev/null

# Source last
source "${ZDOTDIR}/env/compinit.zlogin"
