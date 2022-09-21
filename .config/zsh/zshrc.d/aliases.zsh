#!/usr/bin/env bash

# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias cd..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# mv, rm, cp
alias mv='mv -v'
alias rm='rm -v'
alias cp='cp -v'

# less with colors
alias less="less -FSRXc"

# use coreutils `ls` if possible…
hash gls >/dev/null 2>&1 || alias gls="ls"

# use neovim instead of vim
hash nvim >/dev/null 2>&1 && alias vim="nvim"

# always use color, even when piping (to awk,grep,etc)
if gls --color > /dev/null 2>&1; then colorflag="--color"; else colorflag="-G"; fi;
export CLICOLOR_FORCE=1

# ls options: A = include hidden (but not . or ..), F = put `/` after folders, h = byte unit suffixes
# `la` defined in .functions
alias ls='gls -AFh ${colorflag} --group-directories-first'
alias lsd='ls -l | grep "^d"' # only directories
alias ll='ls -l'

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias diskspace_report="df -P -kHl"
alias free_diskspace_report="diskspace_report"

# Shortcuts
alias vi="vim "
alias v="vim "
alias PlugInstall="vim +PlugInstall"
alias msfc="msfconsole"
alias zshrc="vim ${ZDOTDIR}/.zshrc"

# Vim scratchpad with autosaving
alias scratchpad='vim -c "let g:auto_save = 1" ~/scratchpad/`date +"%m_%d_%Y"`.txt'

# wordprocessor
alias wp='vim --cmd "let g:wp_mode = 1" +WP'

# force git pull, overwriting local changes
alias forcepull='git fetch --all && git reset --hard origin/master'

# port forward VNC ports over SSH
alias sshrdp='ssh -L 9001:localhost:9001 -L 5900:localhost:5900 -L 3283:localhost:3283'

# Grepable history file, with sequential dupes and timestamps removed 
alias hist='cat ${XDG_DATA_HOME}/zsh/.zhistory | cut -d";" -f2 | uniq | head -n -1'

# Show active network interfaces
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# cd into directories on the stack
for index in {1..9}; do alias "$index"="cd +${index}"; done; unset index

# allow aliases to be sudoed
alias sudo='sudo '

alias fnmap='sudo nmap -sS -v --open --min-rate=5000 --max-retries=2 '

# macOS aliases
if [[ "${OSTYPE}" == "darwin"* ]]; then
  # Recursively delete `.DS_Store` files
  alias cleanup_dsstore="find . -name '*.DS_Store' -type f -ls -delete"

  # who is using the laptop's iSight camera?
  alias camerausedby="lsof | grep -wi \"iSight\|VDC\|AppleCamera\" | awk '{print \$2}' | xargs -L1 -I {} ps -p {} -o comm="

  # Show/hide hidden files in Finder
  alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
  alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

  # Hide/show all desktop icons (useful when presenting)
  alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
  alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

  # File size; relies on BSD stat
  alias fs="/usr/bin/stat -f \"%z bytes\""

  # System airport utility
  alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

  # gnu stty
  alias gstty='/usr/local/opt/coreutils/libexec/gnubin/stty'

  # Add stuff to Yoink dropbox
  alias yoink="open -a Yoink"  
  
  # Kitty CLI helper
  alias kitty='/Applications/Kitty.app/Contents/MacOS/kitty'

  # Update all the brews 
  alias brewup="brew update && brew upgrade;"
fi
