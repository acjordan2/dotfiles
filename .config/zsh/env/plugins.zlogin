#!/usr/bin/env zsh

fpath=($ZSH_CONFIG/plugins/zsh-completions/src $fpath) # ZSH Completions
source "$ZSH_CONFIG/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_CONFIG/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" # Source before zsh-history-substring-search
source "$ZSH_CONFIG/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" # Source last
