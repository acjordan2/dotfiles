#!/usr/bin/env zsh

if [[ "${OSTYPE}" == "darwin"* ]]; then
  # Add homebrew and coreutils stuff for macOSj 
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"
  export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"

  # Turn off analytics for homeberw
  export HOMEBREW_NO_ANALYTICS=1
fi

# start in tmux session unless already in a tmux session
# or in an SSH session
if [ -z "${TMUX}" ] && [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then 
  if command tmux -V >/dev/null 2>&1; then
    TMUX_LOG_DIR="${XDG_DATA_HOME}/tmux/log"
    TMUX_SESSION_ID="${${TERM_SESSION_ID%%:*}:-${KITTY_WINDOW_ID}}"
    cd "${TMUX_LOG_DIR}" || { mkdir -p "${TMUX_LOG_DIR}" && cd "${TMUX_LOG_DIR}" }
    { TERM=xterm-256color; tmux -f "${XDG_CONFIG_HOME}/.tmux.conf" new-session -A -s "${TMUX_SESSION_ID}" -c "$HOME" } && exit
  else
    echo "tmux is not installed" 1>&2
  fi
fi

# load extra dotfiles
for file in ${ZDOTDIR}/env/*.zsh; do
    source "${file}"
done

# eval "$(direnv hook zsh)"

zcachedir="${XDG_CACHE_HOME}/zsh/"
[[ -d "$zcachedir" ]] || mkdir -p "$zcachedir"

_update_zcomp() {
    setopt local_options
    setopt extendedglob
    autoload -Uz compinit
    local zcompf="${1}/zcompdump-${ZSH_VERSION}"
    # use a separate file to determine when to regenerate, as compinit doesn't
    # always need to modify the compdump
    local zcompf_a="${zcompf}.augur"

    if [[ -e "${zcompf_a}" && -f "${zcompf_a}"(#qN.md-1) ]]; then
        compinit -C -d "${zcompf}"
    else
        compinit -d "${zcompf}"
        touch "${zcompf_a}"
    fi
    # if zcompdump exists (and is non-zero), and is older than the .zwc file,
    # then regenerate
    if [[ -s "${zcompf}" && (! -s "${zcompf}.zwc" || "${zcompf}" -nt "${zcompf}.zwc") ]]; then
        # since file is mapped, it might be mapped right now (current shells), so
        # rename it then make a new one
        [[ -e "${zcompf}.zwc" ]] && mv -f "${zcompf}.zwc" "${zcompf}.zwc.old"
        # compile it mapped, so multiple shells can share it (total mem reduction)
        # run in background
        zcompile -M "${zcompf}" &!
    fi
}
_update_zcomp "${zcachedir}"
unfunction _update_zcomp
unset file
