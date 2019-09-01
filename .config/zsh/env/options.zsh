# emacs bindings 
bindkey -e

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# ZSH options
setopt noautoremoveslash    # keep the slash when resolving symlinks 
setopt auto_cd              # auto CD into path 
setopt auto_pushd           # push old directory onto the stack
setopt pushd_ignore_dups    # dont push duplicate directories
setopt pushd_silent         # dont print stack
setopt pushd_to_home        # push $home when no arg is supplied

# Change auto complete colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Case insensitive tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# Fuzzy Autocompletion
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 3 numeric
zstyle ':completion:*' matcher-list 'm:{a-z}={  A-Z}' # match upper from lower case

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

## ignores filenames already in the line
zstyle ':completion:*:(rm|kill|diff):*' ignore-line yes

## Ignore completion functions for commands you don't have:
zstyle ':completion:*:functions' ignored-patterns '_*'
