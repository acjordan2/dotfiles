# macOS rewrites/reorders the path via path helper
# after loading .zshenv, which results in homebrew
# bins resolving last. Changing the path via zshrc 
# lets homebrew supercede system utils. 

if [ -f /usr/local/bin/brew ]; then
  # add homebrew and gnutls to the path
  PATH="/usr/local/bin:/usr/local/sbin:/usr/local/opt/coreutils/libexec/gnubin:${PATH}:"

  # man pages for gnutls
  MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"

  # Turn off analytics for homeberw
  HOMEBREW_NO_ANALYTICS=1; export HOMEBREW_NO_ANALYTICS

  # Update all the brews 
  alias brewup="brew update && { brew upgrade; brew cask upgrade; brew cleanup && brew doctor}"
fi

