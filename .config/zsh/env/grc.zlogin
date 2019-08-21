#!/usr/bin/env zsh

if [[ "$TERM" != dumb ]] && (( $+commands[grc] )) ; then

# Prevent grc aliases from overriding zsh completions.
  setopt COMPLETE_ALIASES

  # Supported commands
  cmds=(
    as \
    blkid \
    cc \
    configure \
    cvs \
    df \
    diff \
    dig \
    docker \
    docker-machine \
    du \
    env \
    fdisk \
    findmnt \
    free \
    g++ \
    gas \
    gcc \
    getsebool \
    gmake \
    head \
    id \
    ifconfig \
    ip \
    iptables \
    last \
    ld \
    ldap \
    ls \
    lsblk \
    lsof \
    lspci \
    make \
    mount \
    mtr \
    netstat \
    ping \
    ping6 \
    ps \
    semanage \
    tail \
    traceroute \
    traceroute6 \
    wdiff \
    whois \
    iwconfig \
  );

  # Set alias for available commands.
  for cmd in $cmds ; do
    if (( $+commands[$cmd] )) ; then
      alias $cmd="grc --colour=auto $(whence $cmd)"
    fi
  done

  alias colourify="$GRC -es --colour=auto"

  # Clean up variables
  unset cmds cmd
fi