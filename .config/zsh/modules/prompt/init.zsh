setopt prompt_subst

#Level of dir expansion in prompt
# options are:

# short   first letter of each dir in path, full dirname of the last dir
# long    Full path without expanding '~' 
# full    Full path with '~' expansion
zstyle ":prompt:*" pwd-length 'short'

# show indicator on long running completions
zstyle ':prompt:completing' format '%B%F{9}...%f%b'

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats 'git:%b '

precmd() { 
  promptcmd
  print "" 
} 

autoload -Uz vcs_info
promptcmd() {
  setopt localoptions extendedglob
  local current_pwd="${PWD/#$HOME/~}"

  vcs_info

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

  if [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then
    # {green}$user@$host{/green} {orange}λ{/orange} {blue}$PWD{/blue}
    PROMPT=$'%F{113}%n@%m%f %F{208}$%f %F{6}${ret_directory}\n'
    # ❯❯❯
    PROMPT="${PROMPT}${vcs_info_msg_0_}%B%F{1}❯%F{3}❯%F{2}❯%f%b "

    # error code
    RPROMPT='%(?..[%?] )'
  else
    PROMPT=$'%F{154}%n@%M%f:%f%F{6}%~ $ %F{255}'
  fi
}
