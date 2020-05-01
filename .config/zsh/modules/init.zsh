function jit() {
  emulate -L zsh
  [[ $1.zwc -nt $1 || ! -w ${1:h} ]] && return
  zmodload -F zsh/files b:zf_mv b:zf_rm
  local tmp=$1.tmp.$$.zwc
  {
    zcompile -R -- $tmp $1 && zf_mv -f -- $tmp $1.zwc || return
  } always {
    (( $? )) && zf_rm -f -- $tmp
  }
}

function jit-source() {
  emulate -L zsh
  [[ -e $1 ]] && jit $1 && builtin source -- $1
}

function source() {
  jit-source "${@}" 
}

function load_module() {
  if ! zstyle -m ':module:'${1} loaded 'true'; then
    source "${ZDOTDIR}/modules/${1}/init.zsh" && 
       zstyle ':module:'${1} loaded 'true' ||
       echo "error loading '${1}' plugin'" >&2
  fi
}


# deferred execution for module loading
load_module zsh-defer

# load line-editor helper that is used by other plugins
load_module line-editor

declare -a deferred

# load optional plugins
for i in ${plugins[@]}; do
  IFS=':' read -r -A array <<< "${i}"
  if [[ "${array[2]}" == "defer" ]]; then
    if [[ -n "${array[3]}" ]]; then
      zsh-defer -t "${array[3]}" load_module "${array[1]}"
    else
      zsh-defer load_module "${array[1]}"
    fi
  else
    load_module "${i}"
  fi
done

# load prompt
load_module prompt

if zstyle -m ':modules:compinit' run true; then
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
fi
