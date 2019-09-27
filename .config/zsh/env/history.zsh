#!/usr/bin/env zsh

# Options
setopt BANG_HIST                # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY         # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY            # Share history between all sessions.
setopt INC_APPEND_HISTORY       # Appened to history file as commands are executed
setopt NO_HIST_BEEP             # Don't beep
setopt HIST_EXPIRE_DUPS_FIRST   # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS         # Ignore sequential duplicate commands
setopt HIST_IGNORE_SPACE        # Do not record an event starting with a space.
setopt HIST_VERIFY              # Do not execute immediately upon history expansion.
setopt HIST_REDUCE_BLANKS       # Remove excess blanks

HISTFILE="${XDG_DATA_HOME}/zsh/.zhistory"
HISTSIZE=1000000
SAVEHIST=1000000
HISTORY_IGNORE="(&|[ ]*|exit|ls|bg|fg|history|clear)"  # Don't record some commands

# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
