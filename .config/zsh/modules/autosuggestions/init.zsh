## ZSH AutoSuggestions
source "${ZDOTDIR}/modules/autosuggestions/external/zsh-autosuggestions.zsh" || return 1

ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'

if [[ -n "$key_info" ]]; then
  # vi
  bindkey -M viins "$key_info[Control]F" vi-forward-word
  bindkey -M viins "$key_info[Control]E" vi-add-eol
fi
