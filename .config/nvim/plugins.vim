" Nvim LSP {{{
source $HOME/.config/nvim/plugins/lspsaga.vim

lua << EOF
local nvim_lsp = require'lspconfig'

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    update_in_insert = true,
  }
)

--[[
local on_attach = function(client)
    require'completion'.on_attach(client)

	local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
	buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
end
--]]

require('nvim-lsp-installer').setup {}

-- Setup nvim-cmp.
local cmp = require'cmp'

cmp.setup({
snippet = {
  -- REQUIRED - you must specify a snippet engine
  expand = function(args)
	--vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
	-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
	-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
	vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
  end,
},
mapping = {
  ['<C-n>'] = function(fallback)
	if cmp.visible() then
	  cmp.select_next_item()
	else
	  fallback()
	end
  end,
  ['<C-p>'] = function(fallback)
	if cmp.visible() then
	  cmp.select_prev_item()
	else
	  fallback()
	end
  end,
  ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
  ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
  ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
  ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
  ['<C-e>'] = cmp.mapping({
	i = cmp.mapping.abort(),
	c = cmp.mapping.close(),
  }),
  ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
},
sources = cmp.config.sources({
  { name = 'nvim_lsp' },
  -- { name = 'vsnip' }, -- For vsnip users.
  -- { name = 'luasnip' }, -- For luasnip users.
  { name = 'ultisnips' }, -- For ultisnips users.
  -- { name = 'snippy' }, -- For snippy users.
}, {
  { name = 'buffer' },
})
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
sources = {
  { name = 'buffer' }
}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
sources = cmp.config.sources({
  { name = 'path' }
}, {
  { name = 'cmdline' }
})
})

--[[ Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
capabilities = capabilities
}
--]]

nvim_lsp.bashls.setup{}

--nvim_lsp.pyls.setup{}
nvim_lsp.pyright.setup{
	on_attach=on_attach
}

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

local opts = {
    tools = { -- rust-tools options
        -- automatically set inlay hints (type hints)
        -- There is an issue due to which the hints are not applied on the first
        -- opened file. For now, write to the file to trigger a reapplication of
        -- the hints or just run :RustSetInlayHints.
        -- default: true
        autoSetHints = true,

        -- whether to show hover actions inside the hover window
        -- this overrides the default hover handler
        -- default: true
        hover_with_actions = false,

        runnables = {
            -- whether to use telescope for selection menu or not
            -- default: true
            use_telescope = true

            -- rest of the opts are forwarded to telescope
        },

        inlay_hints = {
            -- wheter to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,

            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<-",

            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix  = "=>",

            -- whether to align to the lenght of the longest line in the file
            max_len_align = false,

            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,

            -- whether to align to the extreme right or not
            right_align = false,

            -- padding from the right if right_align is true
            right_align_padding = 7,
        },

        hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
              {"╭", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╮", "FloatBorder"},
              {"│", "FloatBorder"},
              {"╯", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╰", "FloatBorder"},
              {"│", "FloatBorder"}
            },
        }
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = { -- rust-analyer options
		on_attach = function(_, bufnr)
		  -- Hover actions
		  vim.keymap.set("n", "K", require'rust-tools'.hover_actions.hover_actions, { buffer = bufnr })
		  -- Code action groups
		  vim.keymap.set("n", "<Leader>a", require'rust-tools'.code_action_group.code_action_group, { buffer = bufnr })
		end,
	},
}
require('rust-tools').setup(opts)

local sumneko_binary_path = vim.fn.exepath('lua-language-server')
local sumneko_root_path = vim.fn.fnamemodify(sumneko_binary_path, ':h:h:h')

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
    cmd = {sumneko_binary_path, "-E", sumneko_root_path .. "/main.lua"};
    settings = {
        Lua = {
        runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Setup your lua path
            path = runtime_path,
        },
        diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
        },
        workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
            enable = false,
        },
        },
    },
}

require("null-ls").setup {}

nvim_lsp.ccls.setup{
	on_attach=on_attach
}
nvim_lsp.tsserver.setup {
    on_attach = function(client, bufnr)
        -- disable tsserver formatting if you plan on formatting via null-ls
        client.server_capabilities.document_formatting = false

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
"let g:completion_enable_snippet = 'UltiSnips'
"let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"au BufEnter * lua require'completion'.on_attach()
" }}}

" Telescope {{{
lua << EOF

-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
--[[
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
]]--
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
let g:goyo_width = 82
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
  nnoremap v vipJ
endfunction
fu! Format_par_insert()
	exe "vip"
endfu

function! s:goyo_leave()
  set tw=80 so=0
  nmap j j
  nmap k k
  nmap $ $
  nmap v v
  "au! InsertLeave echo "H"
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
"let g:neotex_pdflatex_alternative='xelatex'

"augroup tex
"	au!
"	au FileType tex NeoTex
"	au FileType tex NeoTexOn
"	au BufEnter *.tex NeoTex
"	au BufEnter *.tex NeoTexOn
"	au QuitPre  *.tex TexCleanUp
"
"	au! BufEnter Notes.tex NeoTex
"
"	au QuitPre tex TexCleanUpFull
"augroup end

" Clean unnecessary files using latexmk
"command! TexCleanUp sil exe "!latexmk -c " . shellescape(expand('%:t'))
"command! TexCleanUpFull sil exe "!latexmk -C " . shellescape(expand('%:t'))
" }}}
" TexMagick {{{
lua << EOF
require('texmagic').setup{
    engines = {
		xelatex = {
			executable = "xelatex",
			args = {"%f"},
			onSave = true
		},
        pdflatex = {    -- This has the same name as a default engine but will be preferred
            executable = "latexmk",
            args = {
                "-pdflatex",
                "-interaction=nonstopmode",
                "-synctex=1",
                "-outdir=.build",
                "-pv",
                "%f"
            },
            isContinuous = false
        },
        lualatex = {    -- This is *not* one of the defaults, but it can be called via magic comment if defined here
            executable = "latexmk",
            args = {
                "-pdflua",
                "-interaction=nonstopmode",
                "-synctex=1",
                "-pv",
                "%f"
            },
            isContinuous = false
        }
    }
}
require('lspconfig').texlab.setup{
    cmd = {"texlab"},
    filetypes = {"tex", "bib"},
    settings = {
        texlab = {
            rootDirectory = nil,
            --      ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
            build = _G.TeXMagicBuildConfig,
            --      ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑ ↑
            forwardSearch = {
                executable = "zathura",
                args = {"%p"}
            }
        }
    }
}
EOF
" }}}
