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
	Plug 'williamboman/nvim-lsp-installer'
	Plug 'hrsh7th/cmp-nvim-lsp', {'branch': 'main'}
	Plug 'hrsh7th/cmp-buffer', {'branch': 'main'}
	Plug 'hrsh7th/cmp-path', {'branch': 'main'}
	Plug 'hrsh7th/cmp-cmdline', {'branch': 'main'}
	Plug 'hrsh7th/nvim-cmp', {'branch': 'main'}

	Plug 'chrisbra/unicode.vim'
	Plug 'nvim-lua/lsp_extensions.nvim'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	"Plug 'neoclide/coc.nvim', {'branch': 'release'}
	"Plug 'mhinz/vim-startify'
	Plug 'khzaw/vim-conceal'
	Plug 'junegunn/goyo.vim'
	Plug 'junegunn/limelight.vim'
	Plug 'vim-airline/vim-airline'
	"Plug 'donRaphaco/neotex', { 'for': 'tex' }
	"Plug 'lervag/vimtex'
	Plug 'jose-elias-alvarez/nvim-lsp-ts-utils', {'branch': 'main'}
	Plug 'jakewvincent/texmagic.nvim', {'branch': 'main'}
	Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }
	Plug 'vimwiki/vimwiki'
	Plug 'lambdalisue/suda.vim'

	" lsp
	Plug 'euclidianAce/BetterLua.vim'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-lua/popup.nvim'
	Plug 'RishabhRD/lspactions'
	Plug 'ThePrimeagen/harpoon'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
	Plug 'HerringtonDarkholme/yats.vim'
	Plug 'kristijanhusak/orgmode.nvim'
	Plug 'sbdchd/neoformat'
	Plug 'tami5/lspsaga.nvim', {'branch': 'nvim6.0'}
	Plug 'pantharshit00/vim-prisma'

" Languages
	Plug 'simrat39/rust-tools.nvim'
	Plug 'p00f/clangd_extensions.nvim'


	Plug 'elkowar/yuck.vim'
	Plug 'jose-elias-alvarez/null-ls.nvim', {'branch': 'main'}
	Plug 'sirtaj/vim-openscad'
	Plug 'dag/vim-fish'
	Plug 'andys8/vim-elm-syntax'
	Plug 'tomlion/vim-solidity'
	Plug 'mxw/vim-jsx'
	Plug 'pangloss/vim-javascript'
	"Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
call plug#end()
" }}}

source $HOME/.config/nvim/sets.vim
source $HOME/.config/nvim/plugins.vim

" Functions{{{
" Ayu colorscheme
function! Ayu()
	colorscheme ayu
	set background=light
endfunction
" Gruvbox colorscheme
function! Gruvbox()
	colorscheme ayu
	set background=light
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

" JS
"au BufWritePre *.js Neoformat
autocmd FileType javascript set formatprg=prettier-eslint\ --stdin

au BufWritePre tex call TexlabBuild

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

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

nnoremap <silent> gf    <cmd>tabfind <cfile><CR>

nnoremap <leader>ar :lua require'lspactions'.rename()<CR>

"}}}
