# Settings for history substring search

source "${ZDOTDIR}/modules/history-substring-search/external/zsh-history-substring-search.zsh" 2>/dev/null || return 1

if [[ -n "$key_info" ]]; then
  # Emacs
  bindkey -M emacs "$key_info[Control]P" history-substring-search-up
  bindkey -M emacs "$key_info[Control]N" history-substring-search-down

  # Vi
  bindkey -M vicmd "k" history-substring-search-up
  bindkey -M vicmd "j" history-substring-search-down

  # Emacs and Vi
  for keymap in 'emacs' 'viins'; do
    bindkey -M "$keymap" '^[[A' history-substring-search-up
    bindkey -M "$keymap" '^[[B' history-substring-search-down
  done

  unset keymap
fi

zstyle ':modules:compinit' run true
