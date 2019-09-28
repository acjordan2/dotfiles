
# ZSH options
setopt noautoremoveslash    # keep the slash when resolving symlinks 
setopt auto_cd              # auto CD into path 
setopt auto_pushd           # push old directory onto the stack
setopt pushd_ignore_dups    # dont push duplicate directories
setopt pushd_silent         # dont print stack
setopt pushd_to_home        # push $home when no arg is supplied
setopt cdable_vars          # Change directory to a path stored in a variable.
setopt multios              # Write to multiple descriptors.
setopt extended_glob        # Use extended globbing syntax.

unsetopt clobber            # Do not overwrite existing files with > and >>.
                            # Use >! and >>! to bypass.
