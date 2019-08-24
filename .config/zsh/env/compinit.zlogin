#!/usr/bin/env zsh

autoload -Uz compinit
if [ $(date +'%j') != $(/usr/bin/stat -f '%Sm' -t '%j' "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION" 2>/dev/null) ]; then
    compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-${ZSH_VERSION}"

    # make sure this check only happens once a day
    touch "${XDG_CACHE_HOME}/zsh/zcompdump-${ZSH_VERSION}"
else
    compinit -C -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
fi

# Execute code in the background to not affect the current session
{
  # Compile zcompdump, if modified, to increase startup speed.
  zcompdump="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"  
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!
