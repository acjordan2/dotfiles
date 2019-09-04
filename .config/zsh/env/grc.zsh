#!/usr/bin/env zsh

if [[ "${TERM}" != dumb ]] && (( ${+commands[grc]} )) ; then

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
    lsblk \
    lsof \
    lspci \
    make \
    mount \
    mtr \
    netstat \
    nmap \
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
  alias colorify="grc -es --colour=auto "
  alias colourify="grc -es --colour=auto "
  for cmd in ${cmds} ; do
    if (( ${+commands[$cmd]} )) ; then
      alias ${cmd}="colourify ${cmd}"
    fi
  done


  # Clean up variables
  unset cmds cmd
fi
