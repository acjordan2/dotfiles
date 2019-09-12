#!/usr/bin/env bash

# remove N bytes from the start or end of a file
ftrim() {
  case "${1}" in 
    -h|--help)
      echo "Usage: ftrim [-b|-e] <bytes> <file>"
      echo "Remove N bytes from the beginning or end of the file"
      echo " "
      echo "options: "
      echo "-b, --begin       Remove bytes from the beginning"
      echo "-e, --end         Remove bytes from the end"
      ;;
    -b|--begin)
      bytes=$(($(/usr/bin/stat -f '%z' "${3}") - ${2}))
      tail -c ${bytes} "${3}"
      ;;
    -e|--end)
      bytes=$(($(/usr/bin/stat -f '%z' "${3}") - ${2}))
      head -c ${bytes} "${3}"
    ;;
    *)
      echo "Usage: ftrim [-b|-e] <bytes> <file>"
      echo "ftrim -h for more info"
      ;;
   esac
}

# Find short hand
f() {
  find . -name "${1}" 2>&1 | grep -v 'Permission denied'
}

# List all files, long format, colorized, permissions in octal
la(){
 	ls -l  "${@}" | awk '
    {
      k=0;
      for (i=0;i<=8;i++)
        k+=((substr($1,i+2,1)~/[rwx]/) *2^(8-i));
      if (k)
        printf("%0o ",k);
      printf(" %9s  %3s %2s %5s  %6s  %s %s %s\n", $3, $6, $7, $8, $5, $9,$10, $11);
    }'
}

# Copy w/ progress
cp_p () {
  rsync -WavP --human-readable --progress "${1}" "${2}"
}

# who is using the laptop's iSight camera?
camerausedby() {
	echo "Checking to see who is using the iSight camera… 📷"
	usedby=$(lsof | grep -w "AppleCamera\|USBVDC\|iSight" | awk '{printf $2"\n"}' | xargs ps)
	echo -e "Recent camera uses:\n${usedby}"
}

# Markdown previews
md() {
    pandoc "${1}" | lynx -stdin
}

# list only the IPs for all interfaces
ipls() {
  local action
  local output

  action="${1}"
  output=""

  if command -v ifconfig >/dev/null; then
    if [[ "${action}" != "-a" ]] && [[ "${action}" != "--all" ]]; then
#        output="$(ifconfig | grep "inet" | grep -v "127.0.0.1" | grep -v "::1" | cut -d" "  -f2 | cut -d"%" -f1 | sort)"
        output=$(command ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, ""); print }')
    else 
      # list all interfaces
      while read -r interface; do
        # get IP for each interface
        while read -r ip; do
          if [ -n "${ip}" ]; then
            output="${output}${interface}: ${ip}\n"
            fi 
        done < <(command ifconfig "${interface}" | grep "inet" | cut -d" "  -f2 | cut -d"%" -f1)
      done < <(command ifconfig -a | sed -E 's/[[:space:]:].*//;/^$/d')
   fi
  fi

  case "${action}" in 
    -4)
        echo "${output}" | grep -v ":"
        ;;
    -6)
        echo "${output}" | grep -v "\."
        ;;
    -h|--help)
        echo "usage: ipls [-4|-6|-a]"
        echo ""
        echo "options"
        echo "-4, -6        Show only IPv4 or IPv6 addresses"
        echo "-a, --all     Show interface label" 
        ;;
    *)
      echo "${output}"
  esac
}

xor() {
  printf '%#x\n' "$((${1} ^ ${2}))"
}

tmux-colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;%smcolour%s\x1b[0m\n" "${i}" "${i}"
  done
}

timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time ${shell} -i -c exit; done
  unset ZLOGIN
}

profzsh() {
  shell=${1-${SHELL}}
  ZPROF=true $shell -i -c exit
}

zsh-list-completions() {
  for command completion in ${(kv)_comps:#-*(-|-,*)}; do
    printf "%-32s %s\n" $command $completion
  done | sort
}

reload(){
  if [ "${1}" = "-f" ]; then
    # force cache files to be rebuilt
    rm -rf ${XDG_CACHE_HOME}/zsh/zcompdump* >/dev/null
  fi

  # Reload the shell (i.e. invoke as a login shell)
  exec ${SHELL} -l
}

# quick look on macOS
ql() {
  if (( $# > 0 )); then
    qlmanage -p "$@" &> /dev/null
  fi
}

# vim as pager
vless() {
  if [ -z "${1}" ] || [ "${1}" = "-" ]; then
    vim -u $xdg_config_home/vim/vimrc.less -
  else
    vim -u $xdg_config_home/vim/vimrc.less "${@}"
  fi
}
