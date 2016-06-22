file="~/.vim"    
[ -f $file ] && [ ! -L $file ] && echo "$file exists and is not a symlink"
