#!/usr/bin/env zsh

HIGHLIGHTER="fsh"

# ZSH Completoins
fpath=(
  ${ZDOTDIR}/plugins/zsh-completions/src
  ${ZDOTDIR}/completion
  ${fpath}
)

## ZSH AutoSuggestions
source "${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_USE_ASYNC=1

# easy switch between highlighters if needed
if [ "${HIGHLIGHTER}" = "fsh" ]; then
  # Fast syntax highlighting
  FAST_WORK_DIR="${ZDOTDIR}/plugins/fast-syntax-highlighting-data"
  source "${ZDOTDIR}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
else
  ## ZSH Syntax highlight
  source "${ZDOTDIR}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" # Source before zsh-history-substring-search
  typeset -A ZSH_HIGHLIGHT_STYLES
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
  ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
  ZSH_HIGHLIGHT_STYLES[function]='fg=magenta'
  ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow'
fi

# ZSH history substring search
source "${ZDOTDIR}/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" # Source last
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
