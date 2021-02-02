" Ruby {{{
augroup filetype_ruby
  autocmd!

  au BufRead,BufNewFile Rakefile,Capfile,Gemfile,.autotest,.irbrc,*.treetop,*.tt set ft=ruby syntax=ruby

  " Ruby.vim {{{
  let ruby_operators = 1
  let ruby_space_errors = 1
  let ruby_fold = 1
  " }}}
augroup END
" }}}
