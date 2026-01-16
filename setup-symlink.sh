#!/usr/bin/env bash
# Symlink dotfiles, configs in $XDG_CONFIG_HOME, and a baseline SSH Config
#
# this is safe to run multiple times and will prompt you about anything unclear
#
# simplified and cleanup version of alrra's nice work here:
#   https://github.com/alrra/dotfiles/blob/master/src/os/create_symbolic_links.sh

# Utilities
print_error() {
    # Print output in red
    printf "\e[0;31m  [✖] %s %s\e[0m\n" "${1}" "${2}"
}

print_info() {
    # Print output in purple
    printf "\n\e[0;35m %s\e[0m\n\n" "${1}"
}

print_question() {
    # Print output in yellow
    printf "\e[0;33m  [?] %s\e[0m" "${1}"
}

print_result() {
    if  [ "${1}" -eq 0 ]; then
        print_success "${2}"
    else
        print_error "${2}"
    fi
    if [ "${3}" = "true" ] && [ "${1}" -ne 0 ]; then
        exit
    fi
}

print_success() {
    # Print output in green
    printf "\e[0;32m  [✔] %s\e[0m\n" "${1}"
}

ask_for_confirmation() {
    print_question "${1} (y/n) "
    read -r -n 1
    printf "\n"
}

answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
        || return 1
}

execute() {
    eval "${1}" #&> /dev/null
    print_result $? "${2:-$1}"
}

symlink() {
  sourceFile="${1}"
  targetFile="${2}"

  if [ -e "${targetFile}" ]; then
      if [ "$(readlink "${targetFile}")" != "${sourceFile}" ]; then
          ask_for_confirmation "'${targetFile}' already exists, do you want to overwrite it?"
          if answer_is_yes; then
              rm -rf "${targetFile}"
              execute "ln -fs ${sourceFile} ${targetFile}" "${targetFile} → ${sourceFile}"
          else
              print_error "${targetFile} → ${sourceFile}"
          fi
      else
          print_success "${targetFile} → ${sourceFile}"
      fi
  else 
      execute "ln -fs \"${sourceFile}\" \"${targetFile}\"" "${targetFile} → ${sourceFile}"
  fi
}

create_dirs() {
  config="$HOME/.config"
  data="$HOME/.local/share"
  cache="$HOME/.cache"


  dirs=("${config}" "${data}" "${cache}")
  extra_dirs=("zsh" "tmux" "nvim" "vim" "bash")

  for i in "${dirs[@]}"; do
      if [ "${i}" != "${config}" ]; then
         for k in "${extra_dirs[@]}"; do
              execute "mkdir -p ${i}/${k}" "mkdir '${i}/${k}'"
         done
      else 
              execute "mkdir -p ${i}" "mkdir '${i}'"
      fi
  done

  execute "mkdir -p $HOME/.local/share/vim/{undo,swaps,backups}" "mkdir '$HOME/.local/share/vim/{undo,swaps,backups}'"
  execute "mkdir -p $HOME/.local/share/tmux/log" "mkdir '$HOME/.local/share/tmux/log"
  execute "mkdir -p $HOME/bin" "mkdir $HOME/bin"
  execute "mkdir -p $HOME/.ssh/control" "mkdir $HOME/.ssh/control"
}

main() {
    local FILES_TO_SYMLINK=()
    local file
    local sourceFile
    local targetFile

    shopt -s dotglob

    # dotfiles in $HOME
    while read -r; do
        FILES_TO_SYMLINK+=("$(echo "${REPLY}" | sed -e 's|//|/|' | sed -e 's|./.|.|')")
    done < <(find . -maxdepth 1 -type f -name ".*" -not -name .DS_Store -not -name '.git*' -not -name .macos)

    # config files in $XDG_CONFIG_HOME
    for dir in .config/*; do
      if [ "$(basename "${dir}")" != ".DS_Store" ]; then
            FILES_TO_SYMLINK+=("${dir}")
        fi
    done

    # SSH configs only
    for file in .ssh/*; do
        if grep -i "PRIVATE KEY" "${file}" -c -q; then 
            # Obviously don't track private keys via git
            print_error "SSH private key found in '${file}'! Key should be removed and rotated"
            return 1
        fi
        FILES_TO_SYMLINK+=("${file}")
    done

    for file in bin/*; do
      FILES_TO_SYMLINK+=("${file}")
    done

    create_dirs

    for file in "${FILES_TO_SYMLINK[@]}"; do
        # Use relative path for symlinks, sometimes I mount my home dir
        sourceFile=$(echo "$(pwd)/${file}" | sed "s/$(echo "${HOME}" | sed 's/\//\\\//g')\///g")
        targetFile="${HOME}/${file}" 
        if [[ "${sourceFile}" = *"/.config/"* ]] || [[ "${sourceFile}" = *"/.ssh/"* ]] || 
          [[ "${sourceFile}" = *"/bin/"* ]] ; then
          sourceFile="../${sourceFile}" 
        fi

        symlink "${sourceFile}" "${targetFile}"
    done

    if [[ "${OSTYPE}" == "darwin"* ]]; then
      # Firefox Config
      for prof in "${HOME}"/Library/Application\ Support/Firefox/profiles/*; do
        if [[ "${prof:l}" == *"default"* ]]; then
          for file in "${XDG_CONFIG_HOME}"/firefox/profiles/Default/*; do
            symlink "${file}" "${prof}/$(basename "${file}")"
          done
        fi
      done
    fi
    
    # Auto pull submodules when updating repo
    git config submodule.recurse true
}

main
