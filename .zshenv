# XDG Base dirs
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_RUNTIME_DIR="${TMPDIR:-/tmp}"

# ZSH dirs
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export ZCACHEDIR="${XDG_CACHE_HOME}/zsh"
export ZDATADIR="${XDG_DATA_HOME}/zsh"

source "${ZDOTDIR}/.zshenv"
