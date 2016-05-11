set nocompatible
set clipboard=unnamed
set esckeys

syntax on
set number
set cursorline
set tabstop=4
set shiftwidth=4 
set softtabstop=4
set expandtab
set mouse=a
set nostartofline
set wildmode=longest,list,full
set wildmenu
set paste

let mapleader=","

noremap <leader>W :w !sudo tee % > /dev/null<CR>

colorscheme monokai
set background=dark

filetype plugin on
set omnifunc=syntaxcomplete#Complete
set laststatus=2


" === Buffer Settings ===
" This allows buffers to be hidden if you've modified a buffer.
set hidden

" To open a new empty buffer
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

" ====== PLUGINS =======

" === Airline ===

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Enable powerline fonts
let g:airline_powerline_fonts = 1

" === CtrlP ===
set runtimepath^=~/.vim/bundle/ctrlp.vim

" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

" Use the nearest .git directory as the cwd
let g:ctrlp_working_path_mode = 'ra'

" Use a leader instead of the actual named binding
nmap <leader>p :CtrlP<cr>

" Easy bindings for its various modes
nmap <leader>bb :CtrlPBuffer<cr>
nmap <leader>bm :CtrlPMixed<cr>
nmap <leader>bs :CtrlPMRU<cr>
