# XDG Base dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_RUNTIME_DIR="${TMPDIR:-/tmp}"

# Bash dirs
export BDOTDIR="${XDG_CONFIG_HOME}/bash"
source "${BDOTDIR}/bashrc"

. "$HOME/.cargo/env"
