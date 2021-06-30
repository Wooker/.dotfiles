syntax on
set number
set autochdir
scriptencoding utf-8

let mapleader = " "

" Colorscheme
set termguicolors
let ayucolor="light"

colorscheme gruvbox
set background=dark

" Tab spaces
set tabstop=4
set shiftwidth=4

" Visual behaviors
set lazyredraw
set visualbell
set list listchars=tab:·\ ,trail:≁,nbsp:∝
set wildmode=list:longest
set showmatch matchtime=2
set ttimeoutlen=10

" Folding
set foldmethod=marker
filetype plugin indent on
"hi Folded term=NONE cterm=NONE
"hi Folded guibg=NONE cterm=NONE

set shortmess+=c
set completeopt=menuone,noinsert,noselect
