" Rust {{{
augroup filetype_rust
  autocmd!
  au FileType rust let g:rustfmt_autosave = 1
  au FileType rust let g:cargo_shell_command_runner = 'Dispatch '
augroup END
" }}
