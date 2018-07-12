#!/usr/bin/env zsh

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# replace system tools with gnutils, e.g. cp, mv, etc
export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$HOME/bin"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# load extra dotfiles
for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
    [ -r "${file}" ] && source "${file}"
done

# Generic colouriser
if [ $(grc 2>&1 | grep -c "not found") -eq 0 ]; then
  source /usr/local/etc/grc.bashrc 2>/dev/null
fi

# highlighting inside manpages and elsewhere
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# Change auto complete colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
autoload -Uz compinit
compinit

# start in tmux session
if [ $(tmux -V 2>&1 | grep -v "not found" -c) -eq 0 ] ; then
  echo "tmux is not installed"
else
    name=$(echo $TERM_SESSION_ID | cut -d ":" -f1)
    if [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then 
      TERM=xterm-256color; tmux attach -t ${name} || { tmux new-session -A -s ${name} };
      exit; 
    fi
fi

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
eval "$(direnv hook zsh)"
