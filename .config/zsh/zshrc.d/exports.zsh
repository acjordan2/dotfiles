#!/usr/bin/env bash

# highlighting inside manpages and elsewhere
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# force vim to follow XDG spec
export VIMINIT=":source ${XDG_CONFIG_HOME}/vim/vimrc"

# here's LS_COLORS
if [[ ! -f "${ZDOTDIR}/zshrc.d/dircolors.zsh" ]]; then
  command -v gdircolors >/dev/null 2>&1 || alias gdircolors="dircolors"
  gdircolors -b "${ZDOTDIR}/zshrc.d/dircolors" >| "${ZDOTDIR}/zshrc.d/dircolors.zsh"
fi
jit-source "${ZDOTDIR}/zshrc.d/dircolors.zsh" 2>/dev/null || source "${ZDOTDIR}/zshrc.d/dircolors.zsh"

eval "$(direnv hook zsh)"
