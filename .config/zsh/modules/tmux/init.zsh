[ -z "${TMUX_TMPDIR}" ] && export TMUX_TMPDIR="${XDG_RUNTIME_DIR:-/tmp}"

# Automatically start tmux when opening a terminal
: "${TMUX_AUTOSTART:=false}"
# Automatically start tmux when connecting from SSH
: "${TMUX_AUTOSTART_SSH:=false}"
# Automatically exit the terminal when tmux is exited
: "${TMUX_AUTOEXIT:=${TMUX_AUTOSTART}}"
# Config file for tmux to use
: "${TMUX_CONFIG:=${XDG_CONFIG_HOME}/tmux/tmux.conf}"
# Tmux log directory
: "${TMUX_LOG_DIR:="${XDG_DATA_HOME}/tmux/log"}"
# Tmux window session ID, set to a static value to force single sessions
: "${TMUX_SESSION_ID:=${TERM_SESSION_ID%%:*}}"
# Minimum amount of time tmux should run, otherwise return error
: "${TMUX_RUNTIME_MIN:=1}"

alias tl="command tmux list-sessions"
alias ta="command tmux attach -t"
alias ts="command tmux new-session"
alias tksv="command tmux kill server"
alias tmux="_tmux_plugin "

# Config location defaults to XDG spec, fall back to tmux default
[ ! -f "${TMUX_CONFIG}" ] && TMUX_CONFIG="${HOME}/.tmux.conf"

# Enable tmux completions for our function in ZSH
# compdef needs to be called after compinit
compdef_plugin+=("_tmux:_tmux_plugin")

function _tmux_plugin() {
  if [[ -n "${*}" ]]; then 
    command tmux "${@}"
  else
    # Try to guess what terminal is being used to
    # create deterministic session IDs, Thia makes it
    # easier to auto re-attach to existing sessions
    if [ -z "${TMUX_SESSION_ID}" ]; then 
      TERM_ID="${TERM_SESSION_ID%%:*}"
      WINDOW_ID="${TERM_ID:-$KITTY_WINDOW_ID}"
      TMUX_SESSION_ID="${WINDOW_ID:-1}"
    fi
    current_directory="${PWD}"
    cd "${TMUX_LOG_DIR}" || return  
    SECONDS=0
    command tmux -f "${TMUX_CONFIG}" new-session -A -s "${TMUX_SESSION_ID}" -c "${current_directory}" 2>&1
    ret_val="$?"
    RUNTIME="${SECONDS}"
    unset SECONDS

    # If the tmux client and server version dont match, tmux will exit but will have an exit code of 0.
    # tmux does not provide an error message so using the SECONDS builtin, we check to see if tmux 
    # closed within $TMUX_RUMTIME_MIN seconds of spawning. If so, dont completely close the shell 
    # to allow for easier debugging 
    if [ "${RUNTIME}" -lt "${TMUX_RUNTIME_MIN}" ] || [ "${ret_val}" != 0 ]; then
      return 1
    fi
  fi
  return
}

if [ -n "${SSH_CLIENT}" ] || [ -n "${SSH_TTY}" ]; then
  TMUX_SSH=true
fi

# autostart tmux session 
if [ -z "${TMUX}" ] &&
  { [ "${TMUX_AUTOSTART}" = "true" ] && [ -z "${TMUX_SSH}" ] } || 
    { [ ${TMUX_AUTOSTART_SSH} = "true" ] && [ "${TMUX_SSH}" = "true"}; then 
  if command tmux -V &>/dev/null; then
    if ! _tmux_plugin ; then
      echo "tmux plugin: tmux exited unepectedly, please check your config and server/client version" >&2
    elif [ "${TMUX_AUTOEXIT}" = "true" ] && [ -z "${TMUX_SSH}" ]; then
      # Don't auto exit for SSH connections
      exit
    fi
  else
    echo "tmux plugin: tmux is not installed" >&2
  fi
fi
