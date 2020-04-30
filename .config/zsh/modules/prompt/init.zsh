if [ -n "${ZSH_THEME}" ]; then
  zstyle ':module:prompt' theme "${ZSH_THEME}"
  zstyle -a ':module:prompt' theme 'prompt_argv'

  source "${ZDOTDIR}/modules/prompt/themes/${ZSH_THEME}/init.zsh"
fi
