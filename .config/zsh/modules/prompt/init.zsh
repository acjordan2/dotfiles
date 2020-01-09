zstyle ':module:prompt' theme "${theme}"
zstyle -a ':module:prompt' theme 'prompt_argv'

source "${ZDOTDIR}/modules/prompt/themes/${theme}/init.zsh"
