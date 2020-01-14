#!/usr/bin/env bash

# General functions go here. shell specific functions go in 
# $XDG_CONFIG_HOME/<shell>/env/functions/

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

list-colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;%smcolour%s\x1b[0m\n" "${i}" "${i}"
  done
}

timeshell() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do export TIMESHELL='true'; /usr/bin/time ${shell} -i -c "exit"; done
}


reload(){
  if [ "${1}" = "-f" ]; then
    # force cache files to be rebuilt
    rm -rf ${XDG_CACHE_HOME}/zsh/zcompdump* >/dev/null
    rm -rf ${XDG_CACHE_HOME}/zsh/*.zwc >/dev/null
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

rand() {
  local charset='[:hex:]'
  local count
  local number_of_results=1
  local output
  local retval
  local seperator="-"
  local words=false
  local pronounceable=false

  declare -a const vowels 
  local const=('b' 'c' 'd' 'f' 'g' 'h' 'j' 'k' 'l' 'm' 'n' 'p' 'r' 's' 't' 'v' 'w' 'x' 'y' 'z')
  local vowels=('a' 'e' 'i' 'o' 'u')

  local DEFAULT_CHAR_COUNT=32
  local DEFAULT_WORD_COUNT=4
  local DEFAULT_PRONOUNCE_COUNT=8

  OPTIND=1
  optspec=":-:hpPwc:C:s:n:"

  while getopts "${optspec}" opt; do
    case "${opt}" in
      -)
        case "${OPTARG}" in
          charset)
            # Indirect expansion that works with ZSH and Bash
            eval "charset=\"\${$OPTIND}\""
            OPTIND=$(( $OPTIND + 1 ))
            ;;
          *)
            echo "rand: unrecognized option '--${OPTARG}'" >&2
            return 1
            ;;
          esac
        ;;
      c)
        if [[ "${OPTARG}" =~ ^[0-9]+$ ]]; then
          count="${OPTARG}"
        else 
          printf "rand: argument '%s' expects an integer but recieved '%s'\n" "${opt}" "${OPTARG}"
          return 1
        fi
        ;;
      n)
        if [[ "${OPTARG}" =~ ^[0-9]+$ ]]; then
          number_of_results="${OPTARG}"
        else 
          printf "rand: argument '%s' expects an integer but recieved '%s'\n" "${opt}" "${OPTARG}"
          return 1
        fi
        ;;
      p)
        charset='[:graph:]'
        ;;
      P)
        pronounceable=true
        ;;
      s)
        seperator="${OPTARG}"
        ;;
      w)
        words=true
        ;;
      h)
        echo "usage: rand [-cnpPsw] [--charset <character set>]"
        echo ""
        echo "Generate a secure random string of words or characters from a given character set (default is '[:hex:]')"
        echo ""
        echo "Arguments:"
        echo "-c          Character/word count."
        echo "              Default character count: ${DEFAULT_CHAR_COUNT}"
        echo "              Default word count: ${DEFAULT_WORD_COUNT}"
        echo "              Default pronounceable count: ${DEFAULT_PRONOUNCE_COUNT}"
        echo "--charset   Character set to use"
        echo "-n          Number of strings to generate"
        echo "-p          Generate a password (shorthand for rand '[:graph:]')"
        echo "-P          Generate a pronounceable word"
        echo "-w          Random words"
        echo "-s          Word Seperator"
        echo "              Default: '-'" 
        return
        ;;
      :)
        printf "rand: option requires and argument -- %s\n" "${OPTARG}"
        return 2
        ;;
      ?)
        printf "rand: unrecognized option '%s'\n" "${OPTARG}"
        return 1
        ;;
    esac
  done
  shift $((OPTIND -1))

  if [ -z "${count}" ]; then
    if ${words}; then
      count="${DEFAULT_WORD_COUNT}"
    elif ${pronounceable}; then
      count="${DEFAULT_PRONOUNCE_COUNT}" 
    else
      count="${DEFAULT_CHAR_COUNT}"
    fi
  fi

  for ((i=1;i<=number_of_results;i++)); do
    if ${words}; then
        output=""
        while read -r; do 
          if [ -n "${output}" ]; then
            output="${output}${seperator}"
          fi

          # Capitalize first letter
          if [ -n "$ZSH_VERSION" ]; then
            output="${output}${(C)REPLY}"
          elif [ -n "$BASH_VERSION" ]; then
            output="${output}${REPLY^}"
          fi

        done< <(shuf --random-source=/dev/urandom /usr/share/dict/words -n "${count}") 
        echo $output
    elif ${pronounceable}; then
      for ((j=1;j<=count;j++)); do
        if [ $((j % 2)) -eq 0 ]; then
          r=$(shuf -i1-5 -n1 --random-source=/dev/urandom)
          printf '%s' "${vowels[$r]}"
        else
          r=$(shuf -i1-21 -n1 --random-source=/dev/urandom)
          printf '%s' "${const[$r]}"
        fi
      done
      echo ""
    else
      # if [ -n "${1}" ]; then
        # charset="${1}"
      # fi
      if [[ "${charset}" == "[:hex:]" ]]; then
        xxd -p -c "${count}" < /dev/urandom | command head -c "${count}"
        retval=$?
      else
        LC_ALL=C tr -dc "${charset}" < /dev/urandom | command head -c "${count}"
        retval=$?
      fi
      echo ""
    fi
  done

  return $retval
}
