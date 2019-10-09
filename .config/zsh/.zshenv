#!/usr/bin/env zsh

if [ -f /usr/local/bin/brew ]; then
  # add homebrew and gnutls to the path
  PATH="${PATH}:/usr/local/bin:/usr/local/sbin:"

  # Turn off analytics for homeberw
  export HOMEBREW_NO_ANALYTICS=1
fi

# Path Stuff
export PATH="${PATH}:${HOME}/bin"

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# neovim as default editor
export EDITOR="${HOME}/bin/editor"
export VISUAL="${EDITOR}"
