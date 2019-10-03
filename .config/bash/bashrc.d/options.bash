#!/usr/bin/env bash

# General options 
set -o noclobber                  # Prevent file overwrite on stdout redirection, use >| to write to existing file
shopt -s checkwinsize             # Update window size after every command
shopt -s globstar 2> /dev/null    # recursiving globbing
shopt -s nocaseglob               # case insensitive globbing
PROMPT_DIRTRIM=2                  # Automatically trim long paths in prompt

# Tab Completion
bind "set completion-ignore-case on"        # Perform file completion in a case insensitive fashion
bind "set completion-map-case on"           # Treat hyphens and underscores as equivalent
bind "set show-all-if-ambiguous on"         # Display matches for ambiguous patterns at first tab press
bind "set mark-symlinked-directories on"    # Immediately add a trailing slash when autocompleting symlinks to directories

# History
shopt -s histappend                                     # Append to the history file, don't overwrite it
shopt -s cmdhist                                        # Save multi-line commands as one command
export HISTFILE="${XDG_DATA_HOME}/bash/bash_history"    # History file location 
export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"  # Don't record some commands
PROMPT_COMMAND='history -a'                             # Record each line as it gets issued
HISTSIZE=500000                                         # Big history
HISTFILESIZE=100000
HISTCONTROL="erasedups:ignoreboth"                      # Avoid duplicate entries
HISTTIMEFORMAT='%F %T '                                 # Use standard ISO 8601 timestamp

## Enable incremental history search with up/down arrows (also Readline goodness)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

# Better directory navigation
shopt -s autocd 2> /dev/null    # Prepend cd to directory names automatically
shopt -s dirspell 2> /dev/null  # Correct spelling errors during tab-completion
shopt -s cdspell 2> /dev/null   # Correct spelling errors in arguments supplied to cd
shopt -s cdable_vars            # Define a variable containing a path and you will be able to cd into it regardless of the directory you're in

## Defines where CD looks for targets
CDPATH="."
