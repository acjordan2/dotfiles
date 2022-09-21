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

# Markdown previews
md() {
    pandoc "${1}" | lynx -stdin
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
  if [[ "${OSTYPE}" == "darwin"* ]]; then
    r_shell=$(ps -o comm= -p $$)
    if [[ "${r_shell}" == "-zsh" ]]; then
      r_shell="zsh"
    fi
  else 
    r_shell=$(readlink /proc/$$/exe)
  fi

  shell=${1-$r_shell}

  for i in $(seq 1 10); do export TIMESHELL='true'; /usr/bin/time ${shell} -i -c "exit"; done
}


reload(){
  if [ "${1}" = "-f" ]; then
    # force cache files to be rebuilt
    rm -rf ${XDG_CACHE_HOME}/zsh/zcompdump* >/dev/null
    find "${ZDOTDIR}/" -type f -name "*.zwc" -delete
  fi

  # Get the path of the current shell's PID
  # to ensure we are reloading the correct
  # shell 
  #
  # @todo replace with proper login shell detection
  # if needed
  if [[ "${OSTYPE}" == "darwin"* ]]; then
    r_shell=$(ps -o comm= -p $$)
    if [[ "${r_shell}" == "-zsh" ]]; then
      r_shell="zsh"
    fi
  else 
    r_shell=$(readlink /proc/$$/exe)
  fi

  # Reload the shell (i.e. invoke as a login shell)
  if [[ "${SHELL}" == "${r_shell}" ]] || [[ $(which "${r_shell}") == "${SHELL}" ]]; then
    exec "${r_shell}" -l
  else
    exec "${r_shell}"
  fi
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
    vim -u ${XDG_CONFIG_HOME}/vim/vimrc.less -
  else
    vim -u ${XDG_CONFIG_HOME}/vim/vimrc.less "${@}"
  fi
}

zdot() {
  local dir="${ZDOTDIR}"
  [[ -n "${1}" ]] && dir="${ZDOTDIR}/${1}"
  cd "${dir}" || return
}

dotfiles() {
  zdot
  local dir="$(git rev-parse --show-toplevel)"
  [[ -n "${1}" ]] && dir="${dir}/${1}"
  cd "${dir}" || return
}

switch-theme () {
  local theme_folders=(
    "${XDG_CONFIG_HOME}/kitty/themes/themes"
    "${XDG_CONFIG_HOME}/tmux/themes"
    "${XDG_CONFIG_HOME}/vim/themes"
  )

  local symlinks=(
    "${XDG_CONFIG_HOME}/kitty/theme.conf"
    "${XDG_CONFIG_HOME}/tmux/theme.conf"
    "${XDG_CONFIG_HOME}/vim/theme.vim"
  )

  local files_to_symlink=()

  theme="${1}.conf"

  for dir in ${theme_folders}; do
    if [[ -f "${dir}/${theme}" ]]; then
      files_to_symlink+=("${dir}/${theme}")
    elif [[ -f "${dir}/${theme//-/_}" ]]; then
      files_to_symlink+=("${dir}/${theme//-/_}")
    else 
      echo "File not found: ${dir}/${theme}"
      return 1
    fi
  done

  index=1
  for f in "${files_to_symlink[@]}"; do
  
    if [[ -L "${symlinks[${index}]}" ]]; then
      command rm "${symlinks[${index}]}"
    fi
    ln -s "${f}" "${symlinks[${index}]}"
    index=$((index + 1))
  done

  sed -i '/### START THEME ###/,/### END THEME ###/d' "${XDG_CONFIG_HOME}/tmux/tmux.conf"
  if [[ "${theme}" = "dracula.conf" ]]; then
    { 
      echo "### START THEME ###"
      cat "${XDG_CONFIG_HOME}/tmux/theme.conf"
      echo "### END THEME ###" 
    } >> "${XDG_CONFIG_HOME}/tmux/tmux.conf"
    tmux source "${XDG_CONFIG_HOME}/tmux/tmux.conf"
  else
    tmux source "${XDG_CONFIG_HOME}/tmux/theme.conf"
  fi
  kitty @ set-colors "${XDG_CONFIG_HOME}/kitty/theme.conf"
  
}

hex() {
  local OPTIND=1
  local delimeter=""
  local output

  while getopts "d:" opt; do
    case "${opt}" in
      d) delimeter="$(printf '%s\n' "${OPTARG}" | sed -e 's/[\/&]/\\&/g')";;
    esac
  done
  shift $(($OPTIND-1))

  output="$(echo -n ${1} | od -A n -t x1)"

  if [[ -z "${delimeter}" ]]; then
    echo "${output}" | sed 's/^[ \t]*//'
  else
    echo "${output}" | sed "s/ /${delimeter}/g"
  fi
}

gitmake() {
  args="${@}"
  gitroot=$(git rev-parse --show-toplevel)

  make -C "${gitroot}" ${args}
}
