#!/usr/bin/env bash

brew update
brew install \
  binutils \
  caskroom/cask/wireshark \
  cfr-decompiler \
  coreutils \
  ctags \
  direnv \
  gnutls \
  go \
  grc \
  jq \
  mitmproxy \
  nmap \
  reattach-to-user-namespace \
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
