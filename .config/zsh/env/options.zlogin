# emacs bindings 
bindkey -e

# ZSH options
setopt noautoremoveslash    # keep the slash when resolving symlinks 
setopt auto_cd              # auto CD into path 

# Add new line before rending prompt 
precmd() { print "" } 

# {green}$user@$host{/green} {orange}λ{/orange} {blue}$PWD{/blue}
PROMPT=$'%F{113}%n@%m%f %F{208}λ%f %F{6}%~\n'

# ❯❯❯
PROMPT="${PROMPT}%B%F{1}❯%F{3}❯%F{2}❯%f%b "

# Change auto complete colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Case insensitive tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

## ignores filenames already in the line
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes

## Ignore completion functions for commands you don't have:
zstyle ':completion:*:functions' ignored-patterns '_*'

## Plugin Options
# ZSH AutoSuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=1

# ZSH Syntax highlight
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[alias]='fg=blue'
ZSH_HIGHLIGHT_STYLES[function]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow'

# ZSH history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
