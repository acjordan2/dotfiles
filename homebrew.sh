#!/usr/bin/env bash

brew update
brew upgrade

declare -a install=(
  bat 
  binutils
  binwalk
  cfr-decompiler
  coreutils
  ctags
  direnv
  fzf
  findutils
  gnu-sed
  gawk
  gnutls
  go
  grc
  grep
  jq
  masscan
  mitmproxy
  neovim
  nmap
  node
  pipenv
  reattach-to-user-namespace
  ripgrep
  shellcheck
  socat
  tmux
  vim
  zsh
)

declare -a cask=(
  wireshark
  kitty
)

echo "## Homebrew packages"
for item in "${install[@]}"; do
  if brew info "${item}" | grep --quiet "Not installed"; then 
    brew install "${item}"
    echo -e "\e[32m${item}\e[49m"
  else
    echo -e "\e[31m${item}\e[49m"
  fi
done

echo "## Cask"
for item in "${cask[@]}"; do
  echo -e "\e[32m${item}"
  if brew cask info "${item}" | grep --quiet "Not installed"; then
    brew cask install "${item}"
    echo -e "\e[32m${item}\e[49m"
  else
    echo -e "\e[31m${item}\e[49m"
  fi
done
