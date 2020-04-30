export TMUX_TMPDIR="${XDG_RUNTIME_DIR:-/tmp}"

SECONDS=0

# start in tmux session unless already in tmux or connected via SSH
if [ -z "${TMUX}" ] && [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then 
  if command tmux -V >/dev/null 2>&1; then
    TMUX_LOG_DIR="${XDG_DATA_HOME}/tmux/log"
    TERM_ID="${TERM_SESSION_ID%%:*}"
    WINDOW_ID="${TERM_ID:-$KITTY_WINDOW_ID}"
    TMUX_SESSION_ID="${WINDOW_ID:-1}"
    cd "${TMUX_LOG_DIR}" || { mkdir -p "${TMUX_LOG_DIR}" && cd "${TMUX_LOG_DIR}" || exit; }
    tmux -f "${XDG_CONFIG_HOME}/tmux/tmux.conf" new-session -A -s "${TMUX_SESSION_ID}" -c "${HOME}" 2>&1
    status_code=$?

    # If the tmux client and server version dont match, tmux will exit but will have an exit code of 0.
    # tmux does not provide an error message so using the SECONDS builtin, we check to see if tmux ]
    # closed within 1 second of spawning. If so, dont completely close the shell to allow for easier debugging 
    if [ "${SECONDS}" -lt 1 ]; then
      echo "tmux session was terminated quickly after starting. Check your config and client/server version" >&2
    elif [ "${status_code}" -eq 0 ]; then
      exit
    fi
  else
    echo "tmux is not installed" >&2
  fi
fi

unset SECONDS
