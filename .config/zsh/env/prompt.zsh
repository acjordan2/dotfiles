# Add new line before rending prompt 
precmd() { print "" } 

if [ -z "${SSH_CLIENT}" ] && [ -z "${SSH_TTY}" ]; then
  # {green}$user@$host{/green} {orange}λ{/orange} {blue}$PWD{/blue}
  PROMPT=$'%F{113}%n@%m%f %F{208}λ%f %F{6}%~\n'
  # ❯❯❯
  PROMPT="${PROMPT}%B%F{1}❯%F{3}❯%F{2}❯%f%b "
else
  PROMPT=$'%F{154}%n@%M%f:%f%F{6}%~ $ %F{255}'
fi
