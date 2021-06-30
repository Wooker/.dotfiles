" Vim-plugged {{{
call plug#begin()
" Snippets
	Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" Colors
	Plug 'morhetz/gruvbox'
	Plug 'chrisbra/Colorizer'
	Plug 'luochen1990/rainbow'
	Plug 'ayu-theme/ayu-vim'
" Tools
	Plug 'neovim/nvim-lspconfig'
	Plug 'kabouzeid/nvim-lspinstall'
	Plug 'nvim-lua/completion-nvim'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	"Plug 'neoclide/coc.nvim', {'branch': 'release'}
	"Plug 'mhinz/vim-startify'
	Plug 'khzaw/vim-conceal'
	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/limelight.vim'
	Plug 'vim-airline/vim-airline'
	Plug 'donRaphaco/neotex', { 'for': 'tex' }
	"Plug 'lervag/vimtex'
	Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
	Plug 'vimwiki/vimwiki'

	Plug 'euclidianAce/BetterLua.vim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-lua/popup.nvim'
	Plug 'ThePrimeagen/harpoon'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
	Plug 'HerringtonDarkholme/yats.vim'
" Languages
	Plug 'rust-lang/rust.vim'
	Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
	Plug 'jose-elias-alvarez/null-ls.nvim'
	Plug 'ron-rs/ron.vim'
	Plug 'octol/vim-cpp-enhanced-highlight'
	Plug 'sirtaj/vim-openscad'
	Plug 'andys8/vim-elm-syntax'
	Plug 'artur-shaik/vim-javacomplete2'
	Plug 'mxw/vim-prolog'
	Plug 'dag/vim-fish'
    Plug 'neoclide/jsonc.vim'
	Plug 'tomlion/vim-solidity'
	"Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
call plug#end()
" }}}

source $HOME/.config/nvim/sets.vim
source $HOME/.config/nvim/plugins.vim

" Functions{{{
" Ayu colorscheme
function! Ayu()
	colorscheme gruvbox
	set background=dark
endfunction
" Gruvbox colorscheme
function! Gruvbox()
	colorscheme gruvbox
	set background=dark
endfunction
"}}}
" Groups and autocomands{{{
augroup nonvim
   au!
   au BufRead *.png,*.jpg,*.pdf,*.gif sil exe "!open " . shellescape(expand("%:p")) | bd | let &ft=&ft
augroup end

" Rofi
au BufNewFile,BufRead *.rasi setf css

" Java
autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType java JCEnable

" R
au BufNewFile,BufRead Renviron, *.Rprofile, *.Rhistory setf r

"}}}
" Commands{{{
command! Confr source $MYVIMRC
command! Confe edit $MYVIMRC

" Dvorak
command! Dvorak sil exe 	"!setxkbmap -layout us,ru -variant dvorak, -option grp:alt_shift_toggle"
command! DvorakQuit sil exe "!setxkbmap -layout us,ru -variant , -option grp:alt_shift_toggle"

" Open .pdf version of current file
command! OpenPDF call jobstart(['xdg-open', expand('%:p:h') . '/' . expand('%:t:r') . '.pdf'])

" MarkDown Presentation
"command! Mdp call jobstart(["urxvt -g 80x40 -e mdp", expand('%:p')])
command! Mdp sil exe "!urxvt -g 80x40 -e mdp " . shellescape(expand('%:p'))

" OpenSCAD
command! Scad call jobstart(['openscad', expand('%:p')])

command! Ayu call Ayu()
command! Gruvbox call Gruvbox()
"}}}
" Remappings{{{
imap jk <esc>
nnoremap <Space>z za

" Edit config
nnoremap <leader>ce :Confe <CR>
nnoremap <leader>cr :Confr <CR>

" Tabs
nnoremap th :tabprevious<CR>
nnoremap tl :tabnext<CR>
nnoremap tn :tabnew<CR>

nmap \l :OpenPDF<CR>
nmap \m :Mdp<CR>
nmap \c :Scad<CR>

"nmap \di : DIstart<CR>
"nmap \ds : DIstop<CR>

" Remove search highlight
nnoremap <silent> <C-c> :nohlsearch<CR><C-L>

" Conceal
"nnoremap <silent> <C-c><C-y> :call ToggleConcealLevel()<CR>

"}}}
