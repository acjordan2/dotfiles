#!/usr/bin/env zsh

if [[ "${OSTYPE}" == "darwin"* ]]; then
  # Add homebrew and coreutils stuff for macOS 
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"
  export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"

  # Turn off analytics for homeberw
  export HOMEBREW_NO_ANALYTICS=1
fi

# start in tmux session unless already in tmux or connected via SSH
if [ -z "${TMUX}" ] && [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then 
  if command tmux -V >/dev/null 2>&1; then
    TMUX_LOG_DIR="${XDG_DATA_HOME}/tmux/log"
    WINDOW_ID="${${TERM_SESSION_ID%%:*}:-${KITTY_WINDOW_ID}}"
    TMUX_SESSION_ID="${WINDOW_ID:-1}"
    cd "${TMUX_LOG_DIR}" || { mkdir -p "${TMUX_LOG_DIR}" && cd "${TMUX_LOG_DIR}" || exit; }
    tmux -f "${XDG_CONFIG_HOME}/tmux/tmux.conf" new-session -A -s "${TMUX_SESSION_ID}" -c "${HOME}" && exit
  else
    echo "tmux is not installed" 1>&2
  fi
fi

declare -a plugins

plugins=( autosuggestions \
          completions \
          directory \
          fast-syntax-highlighting \
          grc \
          history \
          history-substring-search \
        )

# load extra dotfiles
for file in "${ZDOTDIR}"/env/*.zsh; do
    source "${file}"
done

source "${ZDOTDIR}/modules/init.zsh"
