"------------------------------------------------
" Plugins START
call plug#begin()
  Plug 'airblade/vim-gitgutter'
  Plug 'ap/vim-buftabline'
  Plug 'arcticicestudio/nord-vim'
  Plug 'cespare/vim-toml'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'farmergreg/vim-lastplace'
  Plug 'ianks/vim-tsx'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'tpope/vim-commentary'
call plug#end()
" Plugins END
"------------------------------------------------
let g:loaded_python_provider=0
let g:loaded_ruby_provider=0
let g:loaded_node_provider=0
let g:python_host_prog="$HOME/.pyenv/shims/python"
let g:python3_host_prog="$HOME/.pyenv/shims/python"

"------------------------------------------------
" Settings START
let mapleader = "\<Space>"

filetype plugin on
set mouse=a
set nobackup
set noswapfile
set nowritebackup
set number
set signcolumn=yes
set title
set wrap
setlocal wrap
set undodir=/root/.config/nvim/backups
set undofile
set completeopt=longest,menuone
set shortmess+=c   " Shut off completion messages

" set linebreak
" set so=999 " locks scroll to middle of screen
" Settings END
"------------------------------------------------

"------------------------------------------------
" Spell check START
 set nospell spelllang=en_us
 nnoremap <silent> <F6> :set invspell<cr>
 inoremap <silent> <F6> <C-O>:set invspell<cr>
" Spell check END
"------------------------------------------------

let g:markdown_fenced_languages = ['bash=sh', 'rust', 'python']

nmap <Leader>t :call Terminal()<CR>
function! Terminal()
  :set splitbelow
  :set splitright
  :vsplit
  :set laststatus=0
  :set scl=no
  :set nonu
  :term
endfunction
autocmd TermOpen * startinsert

tnoremap <C-h> <C-\><C-n> <bar> :wincmd h<CR>
tnoremap <C-k> <C-\><C-n> <bar> :wincmd l<CR>

tnoremap <Esc> <C-\><C-n> <bar> :call ExitTerminal()<CR>
function! ExitTerminal()
  :set nosplitbelow
  :set nosplitright
  :set laststatus=2
  :set scl=yes
  :set number
  :q!
endfunction

"------------------------------------------------
" Note search START
command! -bang -nargs=* Notes
\ call fzf#vim#grep(
\   "rg
\     --column
\     --line-number
\     --no-heading
\     --color=always
\     --smart-case
\     --passthru
\     ''
\     $NOTES
\   ".shellescape(<q-args>),
\   1,
\   fzf#vim#with_preview(),
\   <bang>0
\ )
"------------------------------------------------

"------------------------------------------------
" Theme START
set cursorline
set hidden
set cmdheight=1
set laststatus=2
set showtabline=2
set list
set listchars=tab:│·,trail:·
set termguicolors
set background=dark

colorscheme nord

" Status line
set statusline=%<%f\ %h%m%r
set statusline+=%=%-10.50{ShowCocStatus()}\ %-.(%l,%c%V%)\ %P

function! ShowCocStatus()
  return get(g:, 'coc_status', '')
endfunc

" Theme END
"------------------------------------------------

"------------------------------------------------
" Remaps START
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> d] <Plug>(coc-diagnostic-next-error)
nmap <silent> d[ <Plug>(coc-diagnostic-prev-error)
nmap <silent> g] :bn<CR>
nmap <silent> g[ :bp<CR>

nmap <C-p> :Rg<Cr>
nmap <C-e> :Files<Cr>
nmap <Leader>n :Notes<CR>
nmap <Leader>ts :let &scrolloff=999-&scrolloff<CR> " ToggleScrolloff

nmap <Leader>e <Plug>(coc-diagnostic-info)
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ga  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)
nmap <expr> <silent> <C-d> <SID>select_current_word()

nnoremap <silent> K :call <SID>show_documentation()<CR>

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" nmap <Leader> e :call <SID>toggle_diagnostics()<CR>

inoremap <silent><expr> <TAB>
\ pumvisible() ? "\<C-n>" :
\ <SID>check_back_space() ? "\<TAB>" :
\ coc#refresh()
" Remaps END
"------------------------------------------------

"------------------------------------------------
" Coc START
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" vscode select multiple words with ctrl-d
function! s:select_current_word()
  if !get(g:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

function! s:toggle_diagnostics()
    call CocActionAsync('diagnosticToggle')
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

