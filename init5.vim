"------------------------------------------------
" Plugins START
call plug#begin()
  Plug 'neovim/nvim-lspconfig'

  Plug 'nvim-lua/completion-nvim'
  Plug 'nvim-lua/diagnostic-nvim'
  Plug 'airblade/vim-gitgutter'
  Plug 'morhetz/gruvbox'
  Plug 'tpope/vim-commentary'
  Plug 'nvim-lua/lsp-status.nvim'
call plug#end()
" Plugins END
"------------------------------------------------

" Required for operations modifying multiple buffers like rename.
set hidden

autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 1000)
lua require'lspconfig'.rust_analyzer.setup({"rust_analyzer"})

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

set statusline=%.48f
set statusline+=%=%.48{LspStatus()}
set statusline+=\ %l
set statusline+=:%1.L

" Statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

" Settings START
let mapleader = "\<Space>"
filetype plugin on
set completeopt+=menuone
set completeopt+=noinsert
set completeopt-=preview
set shortmess+=c   " Shut off completion messages

set mouse=a
set nobackup
set nocompatible
set noswapfile
set nowritebackup
set number
set title
set wrap
setlocal wrap
" Settings END
"------------------------------------------------


"------------------------------------------------
" persist START
set undofile " Maintain undo history between sessions
set undodir=~/.vim/undodir

" Persist cursor
autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
  \ |   exe "normal! g`\""
  \ | endif
" persist END
"------------------------------------------------


"------------------------------------------------
" Theme START
syntax on
colorscheme gruvbox
set background=dark
set cursorline
set hidden
set list
set listchars=tab:»·,trail:·
" Theme END
"------------------------------------------------

"------------------------------------------------
" Remaps START
" Align GitHub-flavored Markdown tables
" Toggle between buffers
nmap <Leader>= :bn<CR>
nmap <Leader>- :bp<CR>

" Remaps END
"------------------------------------------------

