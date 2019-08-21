#!/usr/bin/env zsh

# ZSH Completoins
fpath=(
  $ZDOTDIR/plugins/zsh-completions/src
  $ZDOTDIR/completion
  $fpath
)

source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" # Source before zsh-history-substring-search
source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" # Source last
