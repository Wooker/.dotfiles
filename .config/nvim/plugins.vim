" Nvim LSP {{{
lua << EOF
local nvim_lsp = require'lspconfig'

local on_attach = function(client)
    require'completion'.on_attach(client)

	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end

nvim_lsp.bashls.setup{}

nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,

    settings = {
        ["rust-analyzer"] = {
			--[[
            assist = {
                importGranularity = "module",
                importPrefix = "by_self",
            },
			]]
            cargo = {
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
        }
    }
})
vim.g.rust_fold = 2
vim.g.rust_set_foldmethod = 1

require("null-ls").setup {}

nvim_lsp.tsserver.setup {
    on_attach = function(client, bufnr)
        -- disable tsserver formatting if you plan on formatting via null-ls
        client.resolved_capabilities.document_formatting = false

		local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
		buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        local ts_utils = require("nvim-lsp-ts-utils")

        -- defaults
        ts_utils.setup {
            debug = true,
            disable_commands = false,
            enable_import_on_completion = true,
            import_all_timeout = 5000, -- ms

            -- eslint
            eslint_enable_code_actions = true,
            eslint_enable_disable_comments = true,
            eslint_bin = "eslint",
            eslint_config_fallback = nil,
            eslint_enable_diagnostics = false,

            -- formatting
            enable_formatting = false,
            formatter = "prettier",
            formatter_config_fallback = nil,

            -- parentheses completion
            complete_parens = false,
            signature_help_in_parens = false,

            -- update imports on file move
            update_imports_on_move = true,
            require_confirmation_on_move = false,
            watch_dir = nil,
        }

        -- required to fix code action ranges
        ts_utils.setup_client(client)

        -- no default maps, so you may want to define some here
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gs", ":TSLspOrganize<CR>", {silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "qq", ":TSLspFixCurrent<CR>", {silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", ":TSLspRenameFile<CR>", {silent = true})
        vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", ":TSLspImportAll<CR>", {silent = true})
    end
}
EOF
" }}}
" Completion {{{
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

au BufEnter * lua require'completion'.on_attach()
" }}}
" Telescope {{{
lua << EOF
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = false, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
EOF

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" }}}
" Harpoon {{{
lua << EOF
require("harpoon").setup({
    global_settings = {
        save_on_toggle = false,
        save_on_change = true,
    },
})

EOF

fun! HarpoonNavFileFun()
	:lua require'harpoon.ui'.toggle_quick_menu()
	":lua require'harpoon.ui'.nav_next(id)
endfun

command! HarpoonMenu exe "w | lua require(\"harpoon.ui\").toggle_quick_menu()"
command! HarpoonAddFile exe "lua require(\"harpoon.mark\").add_file()"
command! HarpoonRemoveFile exe "lua require(\"harpoon.mark\")."
"command! -nargs=1 HarpoonNavFile call s:HarpoonNavFileFun(<f-args>)
command! -nargs=1 HarpoonNavFile exe "lua require'harpoon.ui'.nav_file(<f-args>)"

nnoremap <leader>hh :HarpoonMenu <CR>
nnoremap <leader>ha :HarpoonAddFile <CR>
nnoremap <leader>hi :HarpoonNavFile 
nnoremap <leader>1  :lua require'harpoon.ui'.nav_file(1) <CR>
nnoremap <leader>2  :lua require'harpoon.ui'.nav_file(2) <CR>
nnoremap <leader>3  :lua require'harpoon.ui'.nav_file(3) <CR>
nnoremap <leader>4  :lua require'harpoon.ui'.nav_file(4) <CR>
" }}}
" LimeLight {{{
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = '#777777'

" Beginning/end of paragraph
"   When there's no empty line between the paragraphs
"   and each paragraph starts with indentation
let g:limelight_bop = '^\s'
let g:limelight_eop = '\ze\n^\s'
" }}}
" Goyo {{{
let g:goyo_width = 80
let g:goyo_height = '75%'

function! s:goyo_enter()
  set wrap so=999 sbr= linebreak
  nnoremap j gj
  nnoremap k gk
  nnoremap $ g$
  "nnoremap i :Dvorak<CR>i
  "imap jk <esc>:DvorakQuit<CR>
  "Limelight
  " ...
endfunction

function! s:goyo_leave()
  set nowrap tw=80 so=0 sbr=>\
  nmap j j
  nmap k k
  nmap $ $
  "Limelight!
  " ...
endfunction

function! ToggleConcealLevel()
    if &conceallevel == 0
        setlocal conceallevel=2
    else
        setlocal conceallevel=0
    endif
endfunction

au! User GoyoEnter nested call <SID>goyo_enter()
au! User GoyoLeave nested call <SID>goyo_leave()

nmap \<Enter> :Goyo<CR>
" }}}
" Rainbow {{{
let g:rainbow_active = 1 "set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
\	'ctermfgs': ['blue', 'yellow', 'cyan', 'magenta', 'green', 'red'],
\	'guifgs': ['lightblue', 'violet', 'lightcyan', 'lightmagenta', 'lightgreen', 'lightred'],
\	'separately': {
\		'*': {},
\		'vimwiki': {
\			'parentheses_options': 'containedin=markdownCode contained',
\ 		},
\ 	}
\}
" }}}
" VimWiki{{{
let wiki = {}
let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'rust': 'rust'}
"let g:vimwiki_folding = 'expr'
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:vimwiki_root = '~/vimwiki'
let g:vimwiki_listsyms = ' ○◐●✓' "'✗○◐●✓'
"let g:vimwiki_list = [
"	\{'path': '~/vimwiki', 'syntax': 'default', 'ext': '.wiki'},
"	\{'path': '~/vimwiki/vertical_farm', 'syntax': 'default', 'ext':'.wiki'},
"	\{'path': '~/vimwiki/case', 'syntax': 'default', 'ext':'.wiki'}]

function! VimwikiFindIncompleteTasks()
  lvimgrep /- \[ \]/ %:p
  lopen
endfunction

function! VimwikiFindAllIncompleteTasks()
  VimwikiSearch /- \[ \]/
  lopen
endfunction

au! FileType vimwiki set linebreak nowrap 

nmap <Leader>wa :call VimwikiFindAllIncompleteTasks()<CR>
nmap <Leader>wx :call VimwikiFindIncompleteTasks()<CR>
"}}}
" Calendar{{{
let g:calendar_first_day = "monday"
let g:calendar_date_month_name=1
"}}}
" VimTEX {{{
let g:vimtex_mappings_enabled = 0
let g:vimtex_compiler_progname = 'nvr'
" }}}
" Airline {{{
"let g:airline_theme='ayu'
" }}}
" NeoTEX {{{
let g:tex_flavor = 'latex'
let g:neotex_pdflatex_alternative='xelatex'

augroup tex
	au!
	au FileType tex NeoTex
	au FileType tex NeoTexOn
	"au BufEnter *.tex NeoTex
	"au BufEnter *.tex NeoTexOn
	au QuitPre  *.tex TexCleanUp

	au! BufEnter Notes.tex NeoTex

	au QuitPre tex TexCleanUpFull
augroup end

" Clean unnecessary files using latexmk
command! TexCleanUp sil exe "!latexmk -c " . shellescape(expand('%:t'))
command! TexCleanUpFull sil exe "!latexmk -C " . shellescape(expand('%:t'))
" }}}
