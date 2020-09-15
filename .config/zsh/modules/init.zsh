[[ -n "${TMUX}" || "${TMUX_AUTOSTART}" != "true" ]] && [[ "${ZSH_INSTANT_PROMPT}" == "true" ]] && source "${ZDOTDIR}/modules/instant-zsh/init.zsh"

# Compile zsh code for faster exection
# Taken from @romkatv
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

# Compile and source
function jit-source() {
  emulate -L zsh
  [[ -e $1 ]] && jit $1 && builtin source -- $1
}

# Overload to the source built-in to compile
# third party plugin dependencies as they 
# are loaded
function source() {
  emulate -L zsh
  jit-source "${@}" 
}

function load_module() {

  cmd=("jit-source")
  while [[ $# -gt 0 ]]; do
    case "${1}" in
      "--defer"|"-d")
        load_module zsh-defer
        if is_module_loaded 'zsh-defer' && cmd=("zsh-defer" ${cmd[@]})
        shift
        ;;
      "--time"|"-t")
        defer_time="-t ${2}"
        shift; shift
        ;;
      *)
        module="${1}"
        shift
        ;;
    esac
  done

  if ! is_module_loaded ${module}; then
    ${cmd[*]} "${ZDOTDIR}/modules/${module}/init.zsh" && 
       zstyle ':module:'${module} loaded 'true' ||
       echo "error loading '${module}' plugin'" >&2
  fi
}

function list-modules() {
 
  while read -r mod; do
    if is_module_loaded $mod; then 
      echo "${mod}*"
    else
      echo "${mod}"
    fi
  done < <(find ${ZDOTDIR}/modules/* -maxdepth 0 -type d -printf "%f\n")
}

function is_module_loaded() {
  zstyle -m ':module:'${1} loaded 'true'
}

# Helper function to conditionally regenerate the 
# comp file. Speads up shell start-up times
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

declare -a compdef_plugin

# load core modules and dependencies
load_module line-editor

# load optional plugins
# format:
#  ${plugin}:defer?:<seconds to defer>?
for i in ${plugins[@]}; do
  IFS=':' read -r -A array <<< "${i}"
  module="${array[1]}"
  load_module --"${array[2]}" --time "${array[3]}" "${module}"
done

# load last
load_module prompt

# only run comp init if its actually needed
if zstyle -m ':modules:compinit' run true; then
  # run compinit
  zcachedir="${XDG_CACHE_HOME}/zsh/"
  [[ -d "$zcachedir" ]] || mkdir -p "$zcachedir"

  _update_zcomp "${zcachedir}"
  for p in ${compdef_plugin[@]}; do
    IFS=':' read -r -A array <<< "${p}"
    compdef "$array[1]" "$array[2]"
  done
  unfunction _update_zcomp
fi

unfunction source
