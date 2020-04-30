#!/usr/bin/env zsh

if [[ "${TERM}" != dumb ]] && hash grc >/dev/null 2>&1 ; then

  if [ -n "$ZSH_VERSION" ]; then
    # Prevent grc aliases from overriding zsh completions.
    setopt COMPLETE_ALIASES
  fi

  # Set alias for available commands.
  alias colorify="grc -es --colour=auto "
  alias colourify="grc -es --colour=auto "

  declare -a cmds

  # Supported commands
  cmds=(
    as 
    blkid 
    cc 
    configure 
    cvs 
    df 
    diff 
    dig 
    docker 
    docker-machine 
    du 
    env 
    fdisk 
    findmnt 
    free 
    g++ 
    gas
    gcc 
    getsebool 
    gmake 
    head 
    id 
    ifconfig 
    ip 
    iptables 
    last 
    ld 
    ldap 
    lsblk 
    lsof 
    lspci 
    make 
    mount 
    mtr 
    netstat 
    nmap 
    ping 
    ping6 
    ps 
    semanage
    tail 
    traceroute 
    traceroute6 
    wdiff 
    whois 
    iwconfig
  );

  for cmd in ${cmds[@]} ; do
    # if (( ${+commands[$cmd]} )) ; then
    hash "${cmd}" >/dev/null 2>&1 && alias ${cmd}="colourify ${cmd}"
    # fi
  done

  # Clean up variables
  unset cmds cmd
fi
