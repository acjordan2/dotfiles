#!/usr/bin/env bash

brew update
brew install \
  binutils \
  cfr \
  coreutils \
  ctags \
  findutils --with-default-names \
  gnu-sed \
  gnutls \
  go \
  grc \
  grep --with-default-names \
  jq \
  direnv \
  mitmproxy \
  nmap \
  reattach-to-user-namespace \
  tmux \
  vim --with-python3 \
  zsh
