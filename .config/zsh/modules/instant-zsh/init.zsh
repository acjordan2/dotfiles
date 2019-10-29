# ignore if running benchmarks
if [ -z "${TIMESHELL}" ]; then
  source "${ZDOTDIR}/modules/instant-zsh/instant-zsh.zsh"

  # hack for faster prompt loading
  setopt localoptions extendedglob
  local current_pwd="${PWD/#$HOME/~}"

  if [[ "$current_pwd" == (#m)[/~] ]]; then
    ret_directory="$MATCH"
    unset MATCH
  elif zstyle -m ':prompt:*' pwd-length 'full'; then
    ret_directory=${PWD}
  elif zstyle -m ':prompt:*' pwd-length 'long'; then
    ret_directory=${current_pwd}
  else
    ret_directory="${${${${(@j:/:M)${(@s:/:)current_pwd}##.#?}:h}%/}//\%/%%}/${${current_pwd:t}//\%/%%}"
  fi
  unset current_pwd

  # vcs_info

  if [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then
    # {green}$user@$host{/green} {orange}λ{/orange} {blue}$PWD{/blue}
    PROMPT=$'%F{113}%n@%m%f %F{208}$%f %F{6}'${ret_directory}$'\n'
    # ❯❯❯
    PROMPT="${PROMPT}${vcs_info_msg_0_}%B%F{1}❯%F{3}❯%F{2}❯%f%b "

    # error code
    RPROMPT='%(?..[%?] )'
  else
    PROMPT=$'%F{154}%n@%M%f:%f%F{6}%~ $ %F{255}'
  fi
  # PROMPT=$'%F{113}%n@%m%f %F{208}$%f %F{6}\n'
  # PROMPT="${PROMPT}%B%F{1}❯%F{3}❯%F{2}❯%f%b "
  instant-zsh-pre "${PROMPT}"
fi
