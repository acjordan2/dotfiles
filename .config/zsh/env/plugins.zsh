#!/usr/bin/env zsh

# ZSH Completoins
fpath=(
  ${ZDOTDIR}/plugins/zsh-completions/src
  ${ZDOTDIR}/completion
  ${fpath}
)

source "${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "${ZDOTDIR}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" # Source before zsh-history-substring-search
source "${ZDOTDIR}/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" # Source last

# Plugin Options

## ZSH AutoSuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1

## ZSH Syntax highlight
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[alias]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[function]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow'

# ZSH history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
