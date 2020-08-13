"------------------------------------------------
" Plugins START
call plug#begin()
  Plug 'airblade/vim-gitgutter'
  Plug 'cespare/vim-toml'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'ervandew/supertab'
  Plug 'fannheyward/coc-markdownlint', { 'do': 'yarn install --frozen-lockfile && yarn build' }
  Plug 'fannheyward/coc-rust-analyzer', { 'do': 'yarn install --frozen-lockfile && yarn build' }
  Plug 'iamcco/coc-diagnostic', { 'do': 'yarn install --frozen-lockfile && yarn build' }
  Plug 'junegunn/vim-easy-align'
  Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
  Plug 'lotabout/skim.vim'
  Plug 'majutsushi/tagbar'
  Plug 'mhinz/vim-startify'
  Plug 'morhetz/gruvbox'
  Plug 'neoclide/coc-python', { 'do': 'yarn install --frozen-lockfile && yarn build' }
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'neoclide/coc-prettier', { 'do': 'yarn install --frozen-lockfile && yarn build' }
  Plug 'ryanoasis/vim-devicons'
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
call plug#end()
" Plugins END
"------------------------------------------------

"------------------------------------------------
" Settings START
let mapleader = "\<Space>"
filetype plugin on
set completeopt=longest,menuone
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
" fuzzy finding START

" Go to index of notes
nnoremap <leader>ww :e $NOTES_DIR/index.md<CR>cd $NOTES_DIR

command! -nargs=1 Ngrep grep "<args>" -g "*.md" $NOTES_DIR
nnoremap <leader>nn :Ngrep

nnoremap <C-p> :Rg<Cr>
nnoremap <C-e> :Files<Cr>
command! -bang -nargs=* Rg call fzf#vim#rg_interactive(<q-args>, fzf#vim#with_preview('right:70%:wrap', '?'))
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:70%:wrap', '?'),<bang>0)

" fuzzy finding END
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
" startify START
autocmd User Startified setlocal cursorline

let g:startify_enable_special      = 0
let g:startify_files_number        = 8
let g:startify_relative_path       = 1
let g:startify_change_to_dir       = 1
let g:startify_update_oldfiles     = 1
let g:startify_session_autoload    = 1
let g:startify_session_persistence = 1

let g:startify_skiplist = [
  \ 'COMMIT_EDITMSG',
  \ 'bundle/.*/doc',
  \ '/data/repo/neovim/runtime/doc',
  \ '/Users/mhi/local/vim/share/vim/vim74/doc',
  \ ]

let g:startify_custom_header = [ "  Vi the editor of the future" ]
let g:startify_custom_footer = [ "  Vi the editor of the past" ]
" startify END
"------------------------------------------------

"------------------------------------------------
" SuperTab START
let g:SuperTabMappingForward = '<S-tab>'
let g:SuperTabMappingBackward = '<tab>'
" SuperTab END
"------------------------------------------------

"------------------------------------------------
" Theme START
syntax on
colorscheme gruvbox
let g:airline_theme = 'gruvbox'
set background=dark
set cursorline
set hidden
set list
set listchars=tab:»·,trail:·

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#coc#enabled = 1
let g:airline_powerline_fonts = 1
" Theme END
"------------------------------------------------

"------------------------------------------------
" Remaps START
" Align GitHub-flavored Markdown tables
au FileType markdown vmap <Leader><Bslash> :EasyAlign*<Bar><Enter>

" Toggle between buffers
nmap <Leader>= :bn<CR>
nmap <Leader>- :bp<CR>

nmap <silent> <F2> :TagbarToggle<CR>
nmap <silent> <F3> :NERDTreeToggle<CR>
" Remaps END
"------------------------------------------------

"------------------------------------------------
" Coc START
" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" Coc END
"------------------------------------------------
