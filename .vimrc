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

let mapleader=","

noremap <leader>W :w !sudo tee % > /dev/null<CR>

colorscheme monokai
set background=dark

filetype plugin on
set omnifunc=syntaxcomplete#Complete
set laststatus=2
