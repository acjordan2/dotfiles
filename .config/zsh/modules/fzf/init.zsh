# fzf init (portable, no hard dependency on brew)
if (( $+commands[fzf] )); then
  # 1) Homebrew (macOS / Linuxbrew) if available
  if (( $+commands[brew] )); then
    local _brew_prefix
    _brew_prefix="$(brew --prefix 2>/dev/null)"
    if [[ -n "$_brew_prefix" ]]; then
      [[ -r "$_brew_prefix/opt/fzf/shell/key-bindings.zsh" ]] && source "$_brew_prefix/opt/fzf/shell/key-bindings.zsh"
      [[ -r "$_brew_prefix/opt/fzf/shell/completion.zsh"    ]] && source "$_brew_prefix/opt/fzf/shell/completion.zsh"
      unset _brew_prefix
      return 0 2>/dev/null || true
    fi
  fi

  # 2) Common Linux + user install paths
  local _fzf_dirs=(
    "$HOME/.fzf/shell"                 # git install
    "/usr/share/fzf"                   # many distros
    "/usr/share/doc/fzf/examples"      # Debian/Ubuntu common
    "/usr/local/share/fzf"
    "$HOME/.nix-profile/share/fzf"     # nix
  )

  local d
  for d in "${_fzf_dirs[@]}"; do
    [[ -r "$d/key-bindings.zsh" ]] && source "$d/key-bindings.zsh" && break
  done
  for d in "${_fzf_dirs[@]}"; do
    [[ -r "$d/completion.zsh" ]] && source "$d/completion.zsh" && break
  done

  unset _fzf_dirs d
fi
