# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# load extra dotfiles
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$HOME/bin"
for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done

# Generic colouriser
source /usr/local/etc/grc.bashrc 2>/dev/null
source /opt/local/etc/grc.d/grc.bashrc 2>/dev/null

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

# Different theme for SSH Sessions
if [ -n "$SSH_CLIENT" ] && [ -n "$SSH_TTY" ]; then
  prompt peepcode ">"
fi

# Check if tmux is installed
condition=$(tmux -V 2>&1 | grep -v "not found" | wc -l)

# start in tmux session
if [ $condition -eq 0 ] ; then
  echo "$tmux is not installed"
else
  case $- in *i*)
    name=$(echo $TERM_SESSION_ID | cut -d ":" -f1)
    if [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then 
      TERM=xterm-256color; tmux attach -t $name || {tmux new-session -A -s $name}; 
      exit; 
    fi;;
  esac
fi

source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
