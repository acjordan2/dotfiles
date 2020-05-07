if [[ -z "${TIMESHELL}" ]]; then
  if [[ "${TMUX_AUTOSTART}" = "false" || -n "${TMUX}" ]]; then
    if [[ "${ZSH_THEME}" == 'powerlevel10k' ]] || [[ "${ZSH_THEME}" == "p10k"* ]]; then
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block, everything else may go below.
      # ignore if running benchmarks
      if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
        builtin source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
      fi
    elif [[ "${ZSH_THEME}" == "sorin" ]]; then
      builtin source "${ZDOTDIR}/modules/instant-zsh/instant-zsh.zsh"
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
      instant-zsh-post
    fi
  fi
fi
