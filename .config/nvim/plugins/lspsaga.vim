"if !exists('g:loaded_lspsaga') | finish | endif

" code action
nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
nnoremap <silent>K :Lspsaga hover_doc<CR>
vnoremap <silent><leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>

lua << EOF
local saga = require 'lspsaga'

saga.init_lsp_saga()

EOF
