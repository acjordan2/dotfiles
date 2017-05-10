# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
  ZSH_THEME="ys"
else
  # Use theme over SSH sessions
  ZSH_THEME="aussiegeek"
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git docker)

source $ZSH/oh-my-zsh.sh

# User configuration
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$HOME/bin"
for file in ~/.{extra,bash_prompt,exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
#export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7/site-packages
#alias pip="/usr/local/bin/pip"

# Check if tmux is installed, done before alias
condition=$(tmux -V 2>&1 | grep -v "not found" | wc -l)

# start in tmux session
if [ $condition -eq 0 ] ; then
  echo "$tmux is not installed"
else
  case $- in *i*)
    name=$(echo $TERM_SESSION_ID | cut -d ":" -f1)
    if [ -z "$TMUX" ] && [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then TERM=xterm-256color; tmux attach -t $name || {tmux new-session -A -s $name}; exit; fi;;
  esac
fi

