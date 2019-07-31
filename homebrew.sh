#!/usr/bin/env bash

brew update
brew install \
  bat \
  binutils \
  binwalk \
  caskroom/cask/wireshark \
  cfr-decompiler \
  coreutils \
  ctags \
  direnv \
  fzf \
  gnutls \
  go \
  grc \
  jq \
  massscan \
  mitmproxy \
  neovim \
  nmap \
  node \
  reattach-to-user-namespace \
  ripgrep \
  shellcheck \
  socat \
  tmux \
  zsh

brew install \
  findutils \
  gnu-sed \
  grep \
  --with-default-names

brew install vim --with-python3
