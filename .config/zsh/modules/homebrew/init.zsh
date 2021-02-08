# macOS rewrites/reorders the path via path helper
# after loading .zshenv, which results in homebrew
# bins resolving last. Changing the path via zshrc 
# lets homebrew supercede system utils. 

if [ -f /usr/local/bin/brew ]; then
  # add homebrew and gnutls to the path
  PATH="/usr/local/bin:/usr/local/sbin:${PATH}"

  # Turn off analytics for homeberw
  export HOMEBREW_NO_ANALYTICS=1

  # Update all the brews
  alias brewup="brew update && { brew upgrade; brew upgrade --cask; brew cleanup && brew doctor}"
  alias brews="brew list -1"
fi
