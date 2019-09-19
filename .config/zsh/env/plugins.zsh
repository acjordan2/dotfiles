#!/usr/bin/env zsh

# ZSH Completoins
fpath=(
  ${ZDOTDIR}/plugins/zsh-completions/src
  ${ZDOTDIR}/completion
  ${fpath}
)

## ZSH AutoSuggestions
source "${ZDOTDIR}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null && 
{
  ZSH_AUTOSUGGEST_USE_ASYNC=1
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
}

# Fast syntax highlighting
FAST_WORK_DIR="${ZDOTDIR}/plugins/fast-syntax-highlighting-data"
source "${ZDOTDIR}/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" 2>/dev/null

# ZSH history substring search, # Source last
source "${ZDOTDIR}/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" 2>/dev/null && 
{
  # dont set unless we are able to source the plugin
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down 
}
