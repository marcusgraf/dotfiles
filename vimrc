" ==================== Plugins ====================
call plug#begin('~/.vim/plugged')

" Vim standard library
Plug 'tpope/vim-abolish'       " Case insensitive search and camel/snake/mixed-switching
Plug 'tpope/vim-commentary'    " Comment lines with gc
Plug 'tpope/vim-endwise'       " Put in end automatically
Plug 'tpope/vim-eunuch'        " Unix helpers such as :Move, :Rename and :SudoWrite
Plug 'tpope/vim-fugitive'      " Git helpers
Plug 'tpope/vim-projectionist' " Provides alternate file switching, opening the test file etc.
Plug 'tpope/vim-repeat'        " Make . work with plugins
Plug 'tpope/vim-rsi'           " Readline key-mappings for insert and command mode
Plug 'tpope/vim-sleuth'        " Set indentation settings automatically
Plug 'tpope/vim-speeddating'   " Makes C-a and C-x work for dates
Plug 'tpope/vim-surround'      " Change surrounding quotes, tags...
Plug 'tpope/vim-unimpaired'    " Lots of clever pairs of mappings
Plug 'tpope/vim-vinegar'       " Better netrw filebrowser

" Extra text-objects and motions
Plug 'christoomey/vim-sort-motion'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'
Plug 'tommcdo/vim-exchange'
Plug 'wellle/targets.vim'

" Extra features
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
Plug 'AndrewRadev/sideways.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'SirVer/ultisnips'
Plug 'airblade/vim-gitgutter'
Plug 'alcesleo/vim-uppercase-sql'
Plug 'flazz/vim-colorschemes'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/gv.vim'
Plug 'kopischke/vim-fetch' " Handle line:column numbers in filenames
Plug 'rking/ag.vim'
Plug 'vim-scripts/ReplaceWithRegister'

" Tmux
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-tmux-runner'

" Ruby
Plug 'rhysd/vim-textobj-ruby', { 'for': 'ruby' }
Plug 'slim-template/vim-slim', { 'for': 'ruby' }
Plug 'thoughtbot/vim-rspec',   { 'for': 'ruby' }
Plug 'tpope/vim-bundler',      { 'for': 'ruby' }
Plug 'tpope/vim-rake',         { 'for': 'ruby' }
Plug 'tpope/vim-rbenv',        { 'for': 'ruby' }
Plug 'vim-ruby/vim-ruby',      { 'for': 'ruby' }

" Clojure
Plug 'tpope/vim-fireplace',                        { 'for': 'clojure' }
Plug 'tpope/vim-salve',                            { 'for': 'clojure' }
Plug 'guns/vim-sexp',                              { 'for': 'clojure' }
Plug 'tpope/vim-sexp-mappings-for-regular-people', { 'for': 'clojure' }

" Rust
Plug 'cespare/vim-toml'
Plug 'rust-lang/rust.vim'

" Elixir
Plug 'elixir-lang/vim-elixir', { 'for': 'elixir' }

" Go
Plug 'fatih/vim-go', { 'for': 'go' }

" Trial
Plug 'tpope/vim-liquid'
Plug 'EdJoJob/llvmir-vim'
Plug 'kchmck/vim-coffee-script'
Plug 'majutsushi/tagbar'

call plug#end()

runtime macros/matchit.vim

syntax on

" ==================== Theme ====================

" List of colors here: https://github.com/flazz/vim-colorschemes/tree/master/colors
colorscheme blackboard
highlight SpellBad ctermbg=52
highlight Pmenu ctermbg=59 ctermfg=15
highlight PmenuSel ctermbg=226 ctermfg=0
highlight Folded ctermfg=0
highlight CursorLine ctermbg=233 cterm=NONE
highlight ColorColumn ctermbg=233
highlight Todo ctermfg=white ctermbg=none

" No split separator char
set fillchars+=vert:\  " There's significant whitespace before this comment

" ==================== autocmds ====================
augroup settings
    " Make sure to not register the autocmds again when reloading vimrc
    autocmd!

    " Reload .vimrc on save
    autocmd BufWritePost vimrc source $MYVIMRC

    " Don't insert comments with O
    autocmd FileType * setlocal formatoptions-=o

    autocmd InsertEnter * set cursorline
    autocmd InsertLeave * set nocursorline

    " Automatically rebalance splits on resize
    autocmd VimResized * :wincmd =

    " Add syntax highlighting for some special files
    autocmd BufNewFile,BufRead *.lasp setlocal filetype=clojure
    autocmd BufNewFile,BufRead alias,bash_profile,.env*,path,railsrc setlocal filetype=sh
    autocmd BufNewFile,BufRead emacs setlocal filetype=lisp
    autocmd BufNewFile,BufRead gitconfig setlocal filetype=gitconfig
    autocmd BufNewFile,BufRead pryrc setlocal filetype=ruby
augroup END

" ==================== Whitespace ====================
" Highlight EOL whitespace, http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight default ExtraWhitespace ctermbg=darkred guibg=darkred

augroup whitespace
    autocmd!

    autocmd BufRead * match ExtraWhitespace /^\s\+$/

    " The above flashes annoyingly while typing, be calmer in insert mode
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
augroup END

function! TrimWhitespace()
    let l:save_cursor = getpos('.')

    " Remove trailing whitespace at the end of lines
    silent! execute ':%s/\s\+$//'

    " Remove trailing newlines at the end of file
    silent! execute ':%s/\($\n\s*\)\+\%$//'

    call setpos('.', l:save_cursor)
endfunction

command! TrimWhitespace execute ':call TrimWhitespace()'


" ==================== Settings ====================
" Make backspace work as expected
set backspace=indent,eol,start

" General settings
set autoread
set clipboard=unnamed " Yank to system clipboard
set diffopt+=vertical
set gdefault          " Replace all matches by default
set hidden
set lazyredraw        " Don't redraw until macro has finished running
set listchars+=tab:»·
set nojoinspaces      " Join lines containing punctuation correctly
set nowrap
set number
set path+=**          " Find subdirectories of path
set sidescroll=1      " Scroll sideways smoothly
set synmaxcol=512     " Turn of syntax for absurdly long lines (makes opening huge json-files quick)
set ttyfast           " Indicates a fast terminal connection, enabling smoother redraws
set wildignorecase
set wildmenu

" Ignore case if all lowercase
set ignorecase
set smartcase
set incsearch
set nohlsearch " This makes using / for navigation less obnoxious, it can quickly be toggled on with coh

" Default indentation settings
set expandtab
set shiftround
set shiftwidth=4
set softtabstop=0
set tabstop=8

" More natural split destinations
set splitbelow
set splitright

" Don't need it
set nobackup
set noswapfile

" Persistent undo
set undodir=~/.vim/undo
set undofile

" Enable per project vimrc:s
set exrc
set secure

" Share spellfile in Dropbox
set spellfile=~/Dropbox/apps/vim/en.utf-8.add

" Fix escape lag
set ttimeout
set ttimeoutlen=1

" Statusline
set laststatus=2
set statusline=\ %F                                     " Path
set statusline+=\ %y                                    " File type
set statusline+=\ (%{fugitive#head(8)})                 " Git branch
set statusline+=%=                                      " Right align after this
set statusline+=\ %{&ff}\                               " Fileformat
set statusline+=\ Line:\ %l/%L\ (%P)\ \|\ Column:\ %c\  " Line/Column

" Enable mouse operation
set mouse=a
if !has('nvim')
    set ttymouse=xterm2
endif

" NeoVim specific settings
if has('nvim')
    " Escape in terminal mode
    tnoremap <Esc><Esc> <C-\><C-n>

    " Thin cursor in insert mode
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

    " Increase scrollback in terminal mode
    let g:terminal_scrollback_buffer_size=10000
endif

" Load shell aliases
let $BASH_ENV = '~/.alias'

" ==================== Vim++ mappings ====================
" This first section of mappings I categorize as either fixing or
" supercharging Vim's behaviour - it fixes flaws, makes standard commands
" better and fills holes in Vim's interface.
"
" Basically - anything I think should be standard Vim goes here:

" U for normal redo is much more natural
nnoremap U <C-r>

" Enable @@ usage over several lines in visual mode
xnoremap @@ :normal @@<CR>

" Repeat command over multiple lines in visual mode
xnoremap . :normal .<CR>

" Y yanks to the end of the line, entire line is still available with yy
nnoremap Y y$

" More natural movements to line extremes
noremap gh ^
noremap gl $

" Make * and # search for selection in visual mode
xnoremap * "xy/\V<C-r>=escape(@x, '/\')<CR><CR>
xnoremap # "xy?\V<C-r>=escape(@x, '?\')<CR><CR>

" Search command history with C-p and C-n
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Better and more consistent &
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Correct J and gJ to take a motion, and act on current line when doubled.
"
" To not interfere with my overridden HJKL motions, J is moved to gj, which is
" otherwise a pretty useless command to use manually.
"
" To join a paragraph, normally you first have to select it by doing vipJ,
" this makes J take a motion so you can do Jip, and you can still get the old
" behaviour by doing JJ and gJJ, this is much more consistent with other Vim
" commands.
nnoremap <silent> J :set operatorfunc=JoinOperator<CR>g@
nnoremap <silent> gJ :set operatorfunc=GJoinOperator<CR>g@
nnoremap JJ J
nnoremap gJJ gJ

function! JoinOperator(submode)
    '[,']join
endfunction

function! GJoinOperator(submode)
    '[,']join!
endfunction


" ==================== Key mappings ====================

" Navigate wrapped lines easier
nnoremap j gj
nnoremap k gk

" Shift-; to do the opposite of ; makes a lot of sense, and : now gets the
" prime real estate it deserves.
noremap : ,
noremap , :

" Run the q macro instead of stupid Ex-mode
nnoremap Q @q

" Run the q macro over multiple lines
xnoremap Q :normal @q<CR>

" Quickly clear search highlights
nnoremap <silent> <C-l> :nohlsearch<CR>:diffupdate<CR><C-l>

" Save and trim whitespace with C-s
nnoremap <C-s> :TrimWhitespace<CR>:write<CR>
vmap <C-s> <Esc><C-s>gv
imap <C-s> <Esc><C-s>l

" ==================== Leader commands ====================
" Mappings that I haven't found a better key combination for yet.

let g:mapleader="\<Space>"
let g:maplocalleader="\<Space>"

" Manually reload vimrc
nnoremap <Leader>r :source $MYVIMRC<CR>

" Go to last file
nnoremap <Leader><Leader> <C-^>

" Close
nnoremap <Leader>q :q<CR>

" Highlight word but don't jump to the next match
nmap <Leader>* *``
nmap <Leader># #``
xmap <Leader>* *``
xmap <Leader># #``

" Toggle folding methods
function! ToggleFoldMethods()
    if &foldmethod ==# 'manual'
        setlocal foldmethod=indent
        echo ':setlocal foldmethod=indent'
    else
        setlocal foldmethod=manual
        echo ':setlocal foldmethod=manual'
    endif
endfunction
nnoremap <Leader>f :call ToggleFoldMethods()<CR>

" Maximize split in new tab, almost like <prefix>z in tmux
nnoremap <Leader>z :silent tabedit %<CR>

" Wrap until end of line in parenthesis
nmap <Leader>( lysg_)

" Black hole redirection
nnoremap <Leader>d "_d
xnoremap <Leader>d "_d
nnoremap <Leader>x "_
xnoremap <Leader>x "_

" Quick paste last yank
nnoremap <Leader>p "0p
xnoremap <Leader>p "0p

" Count matches from last search
nnoremap <Leader>c :%s///n<CR>
xnoremap <Leader>c :s///n<CR>

" Set 2 or 4 space indent
nnoremap <Leader>2 :set expandtab shiftwidth=2<CR>
nnoremap <Leader>4 :set expandtab shiftwidth=4<CR>

" Set colorcolumn to 80 or 120 columns
nnoremap <Leader>8 :set colorcolumn=80<CR>
nnoremap <Leader>9 :set colorcolumn=120<CR>
nnoremap <Leader>0 :set colorcolumn=<CR>

" Use filetype shell easily for files which are not detected
nnoremap <Leader>s :set filetype=sh<CR>

" ==================== Custom commands ====================
command! Nmappings execute 'redir! > /tmp/vim_mappings.txt | silent nmap | redir END | !less /tmp/vim_mappings.txt'
command! Mappings execute 'redir! > /tmp/vim_mappings.txt | silent map | redir END | !less /tmp/vim_mappings.txt'

command! MakeDirectories execute '!mkdir -p %:h'

command! CopyPathToClipboard execute "let @* = substitute(expand('%:p'), '/Users/alcesleo', '~', '')"

" Find out the highlighting group under the cursor
function! HighlightGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfunction
command! HighlightGroup call HighlightGroup()

" Make README easier to type
iabbrev readme README

" ==================== Plugin settings ====================

" Commentary
let g:commentary_map_backslash=0

" FZF
nnoremap <C-p> :FZF<CR>

" Targets
let g:targets_nlNL = 'nN  '

" EasyAlign
vmap g<Space> <Plug>(EasyAlign)
nmap g<Space> <Plug>(EasyAlign)

" Support vim comments too
let g:easy_align_delimiters = { '"': { 'pattern': '"\+', 'delimiter_align': 'l', 'ignore_groups': ['!Comment']  } }

" Fugitive
nnoremap <Leader>ga :Gwrite<CR>
nnoremap <Leader>gc :Gcommit -v<CR>
nnoremap <Leader>gf :Gwrite<CR>:Gcommit -v<CR>i
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gp :Gpush<CR>
nnoremap <Leader>gb :Gblame<CR>
nnoremap <Leader>gh :Gbrowse<CR>
xnoremap <Leader>gh :Gbrowse<CR>

" Gitgutter
let g:gitgutter_realtime = 0
let g:gitgutter_eager    = 0
let g:gitgutter_map_keys = 0
let g:gitgutter_sign_removed_first_line = '_^'
let g:gitgutter_sign_column_always = 1
nmap <Leader>gA <Plug>GitGutterStageHunk
nmap <Leader>gu <Plug>GitGutterRevertHunk
nmap [h <Plug>GitGutterPrevHunk
nmap ]h <Plug>GitGutterNextHunk

highlight SignColumn ctermbg=black
highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=yellow
highlight GitGutterDelete ctermfg=red
highlight GitGutterChangeDelete ctermfg=166

" UltiSnips
let g:UltiSnipsExpandTrigger='<Tab>'
let g:UltiSnipsJumpForwardTrigger='<Tab>'
let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'

" AutoPairs
let g:AutoPairs = {'(':')', '[':']', '{':'}', "'":"'", '"':'"', '`':'`'}
let g:AutoPairsMultilineClose = 0
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutToggle = ''

" Disable some vim-sexp mappings to make space for tmux navigator
let g:sexp_mappings = {
    \ 'sexp_swap_list_backward':    '',
    \ 'sexp_swap_list_forward':     '',
    \ 'sexp_swap_element_backward': '',
    \ 'sexp_swap_element_forward':  '',
    \ }
let g:sexp_enable_insert_mode_mappings = 0

" Tmux Navigator
let g:tmux_navigator_no_mappings = 1
" Mend the relevant meta-combinations
set <M-h>=h
set <M-j>=j
set <M-k>=k
set <M-l>=l
set <M-o>=o
nnoremap <silent> <M-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <M-j> :TmuxNavigateDown<CR>
nnoremap <silent> <M-k> :TmuxNavigateUp<CR>
nnoremap <silent> <M-l> :TmuxNavigateRight<CR>
nnoremap <silent> <M-o> :TmuxNavigatePrevious<CR>
inoremap <silent> <M-h> <Esc>:TmuxNavigateLeft<CR>
inoremap <silent> <M-j> <Esc>:TmuxNavigateDown<CR>
inoremap <silent> <M-k> <Esc>:TmuxNavigateUp<CR>
inoremap <silent> <M-l> <Esc>:TmuxNavigateRight<CR>
inoremap <silent> <M-o> <Esc>:TmuxNavigatePrevious<CR>

" Tmux Runner
let g:VtrClearSequence = "q"
nnoremap <silent> TA :VtrAttachToPane<CR>
nnoremap <silent> TC :VtrSendCommandToRunner<CR>
nnoremap <silent> TT :VtrSendLinesToRunner<CR>
xnoremap <silent> TT :VtrSendLinesToRunner<CR>

" Switch
let g:switch_mapping = '<Tab>'

" SplitJoin
let g:splitjoin_split_mapping = 'cS'
let g:splitjoin_join_mapping  = 'cJ'
let g:splitjoin_trailing_comma = 1

" Sideways
nnoremap <e :SidewaysLeft<CR>
nnoremap >e :SidewaysRight<CR>

" Go
let g:go_fmt_command = "goimports"
let g:go_fmt_fail_silently = 1

" TagBar
nnoremap <F8> :TagbarToggle<CR>
