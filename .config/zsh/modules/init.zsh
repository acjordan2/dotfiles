function load_modules() {
  local i
  for i in ${plugins[@]}; do
    source "${ZDOTDIR}/modules/${i}/init.zsh"
  done
}

# load line-editor helper that is used by other plugins
source "${ZDOTDIR}/modules/line-editor/init.zsh"

# load optional plugins
load_modules

# load prompt
source "${ZDOTDIR}/modules/prompt/init.zsh"

# run compinit
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
