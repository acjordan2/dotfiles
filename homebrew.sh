#!/usr/bin/env bash

brew update
brew install \
  binutils \
  binwalk \
  bat \
  cfr-decompiler \
  coreutils \
  caskroom/cask/wireshark \
  ctags \
  gnutls \
  go \
  grc \
  jq \
  direnv \
  massscan \
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
