"""""""""""""""""""""""""""""""""""
" Edit vimrc with:    `<Leader>ve`"
" Reload vimrc with:  `<Leader>vr`"
" Open/Close folds with:      `za`"
"""""""""""""""""""""""""""""""""""

" Map leader key.
let mapleader = "\\"

""" Vundle ---------------------------- {{{

set nocompatible           " be iMproved, required for Vundle
filetype off               " required for Vundle, will be turned on later

set rtp+=~/.vim/bundle/Vundle.vim  " required for Vundle

" Vundle help:
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
"                   - Or call `vim +PluginInstall +qall` from the command line
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " Vundle manages itself

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'https://github.com/joshdick/onedark.vim'

" Disable tmuxline because the theme is incompatible with auto-setting colors on mode change
" Plugin 'edkolev/tmuxline.vim'

Plugin 'christoomey/vim-tmux-navigator'
Plugin 'tmux-plugins/vim-tmux-focus-events'
Plugin 'tmux-plugins/vim-tmux'
Plugin 'roxma/vim-tmux-clipboard'

Plugin 'sheerun/vim-polyglot'
Plugin 'vim-scripts/AutoComplPop'
Plugin 'airblade/vim-gitgutter'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'preservim/nerdcommenter'

" Plugin 'weynhamz/vim-plugin-minibufexpl'
" Plugin 'preservim/tagbar'

" Must be after Airline, CtrlP, etc.
Plugin 'ryanoasis/vim-devicons'

" Defined before `vim-buffet` is loaded:
function! g:BuffetSetCustomColors()
  hi! BuffetCurrentBuffer cterm=none ctermbg=7 ctermfg=1 
  hi! BuffetActiveBuffer cterm=none ctermbg=0 ctermfg=7
  hi! BuffetBuffer cterm=none ctermbg=0 ctermfg=7
  hi! BuffetTrunc cterm=none ctermbg=0 ctermfg=8
  hi! BuffetTab cterm=none ctermbg=0 ctermfg=7
endfunction
" Must be after vim-devicons
Plugin 'bagrat/vim-buffet'

"""
" After adding a new plugin, run `:PluginInstall`
"""
call vundle#end()

filetype plugin indent on

" }}}

""" Basics ---------------------------- {{{

set cursorline  " highlight current line
set number      " Show line numbers
set ruler       " Show row and column ruler information
set showmatch   " Highlight matching brace
set wildmenu    " visual autocomplete for command menu
set wildmode=longest:list,full

set undolevels=1000             " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour

set foldmethod=indent " fold based on indent level
set foldlevel=10      " fold the 10th indent

set hlsearch    " Highlight all search results
set ignorecase  " Always case-insensitive
set incsearch   " Searches for strings incrementally
set smartcase   " Enable smart-case search

set updatetime=100

" Disable backups and .swp files.
set nobackup
set noswapfile
set nowritebackup

" Indentation settings.
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set nowrap

set list
set listchars=eol:⏎,tab:┊\ ,trail:●,extends:…,precedes:…,space:·

" Use system clipboard.
set clipboard=unnamedplus

set mouse=i " Enable mouse scrolling and other behaviors in insert mode

" Don't complain about unsaved files when switching buffers.
set hidden
" set nohidden

" Autoreload files that change outside of vim
set autoread

" }}}

""" Colors & Airline Settings --------- {{{
let g:airline_powerline_fonts = 0
let g:airline_theme = 'onedark'
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
    if (has("nvim"))
        "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    endif
    "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
    "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
    " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
    if (has("termguicolors"))
        set termguicolors
    endif
endif

" Disable custom editor background when running in a terminal, let terminal color show through
if (has("autocmd") && !has("gui_running"))
    augroup colorset
        autocmd!
        let s:white = { "gui": "#ABB2BF", "cterm": "145", "cterm16" : "7" }
        autocmd ColorScheme * call onedark#set_highlight("Normal", { "fg": s:white }) " `bg` will not be styled since there is no `bg` setting
    augroup END
endif

" Vertical bar between splits that's connected top + bottom
set fillchars+=vert:\▏
syntax on
set background=dark
colorscheme onedark

" }}}

""" Functions ------------------------- {{{

" Trim trailing whitespace in the file.
command! TrimWhitespace %s/\s\+$//e

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" }}}

""" Bindings -------------------------- {{{

" The optional `nore` segment means that the RHS is not itself a mapped sequence.
" :[nore]map  => normal mode, visual + select, operator-pending
" :n[nore]map => normal mode
" :v[nore]map => visual + select
" :o[nore]map => operator-pending

nnoremap <Leader>] <C-]>            " Jump to ctags tag definition.

nnoremap <Leader>ve :e $MYVIMRC<cr>  " Edit .vimrc file
nnoremap <Leader>vr :so $MYVIMRC<cr> " Reload .vimrc file
nnoremap <Leader>rr :redraw!<cr>     " Redraw screen to fix visual problems
nnoremap <Leader>w :w<CR>            " Write a file.

" Absolute movement for word-wrapped lines.
nnoremap j gj
nnoremap k gk

" }}}

""" Buffers & Splits ------------------ {{{
nnoremap <leader>T :enew<cr> " To open a new empty buffer
nnoremap <leader>bq :bp<bar>sp<bar>bn<bar>bd<CR> " Close buffer and move to previous

set splitbelow
set splitright

let g:tmux_navigator_no_mappings = 1
" Vim Style split navigation
nnoremap <C-A>h :TmuxNavigateLeft<cr>     " Move to split Left
nnoremap <C-A>j :TmuxNavigateDown<cr>     " Move to split Down
nnoremap <C-A>k :TmuxNavigateUp<cr>       " Move to split Up
nnoremap <C-A>l :TmuxNavigateRight<cr>    " Move to split Right
nnoremap <C-A>\ :TmuxNavigatePrevious<cr> " Move to the previous split
" Arrow Style split navigation
nnoremap <C-A><Left>  :TmuxNavigateLeft<cr>  " Move to split Left
nnoremap <C-A><Down>  :TmuxNavigateDown<cr>  " Move to split Down
nnoremap <C-A><Up>    :TmuxNavigateUp<cr>    " Move to split Up
nnoremap <C-A><Right> :TmuxNavigateRight<cr> " Move to split Right

" Vim Style split resizing
nnoremap <C-A>H <C-w>5< " Make split narrower
nnoremap <C-A>J <C-w>5+ " Make split shorter
nnoremap <C-A>K <C-w>5- " Make split taller
nnoremap <C-A>L <C-w>5> " Make split wider:
" Arrow style split resizing
nnoremap <C-A><S-Left>  <C-w>5< " Make split narrower
nnoremap <C-A><S-Up>    <C-w>5- " Make split shorter
nnoremap <C-A><S-Down>  <C-w>5+ " Make split taller
nnoremap <C-A><S-Right> <C-w>5> " Make split wider:

" }}}

""" Plugins

""" GitGutter ------------------------- {{{

let g:gitgutter_map_keys = 0

" }}}

""" GutenTags ------------------------- {{{

let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", ".git", "node_modules", "*.vim/bundle/*"]

" }}}

""" FZF ------------------------------- {{{

"search project files
nnoremap <leader>p :FZF<cr>
"search project files by lines of code
nnoremap <leader>o :Lines<cr>
"search project files by tags (requirs ctags to be installed)
nnoremap <leader>t :Tags<cr>
"search all open files/buffers
nnoremap <leader>r :Buffers<cr>

let g:fzf_layout = { 'down': '40%' }

" }}}

""" NERDCommenter --------------------- {{{

let g:NERDCreateDefaultMappings = 0
nmap <C-z> <Plug>NERDCommenterToggle
vmap <C-z> <Plug>NERDCommenterToggle

" }}}

""" NetRW ------------------------------ {{{

let g:netrw_banner = 0
let g:netrw_liststyle = 3
" 0 - open file in the same window
" 1 - open files in a new horizontal split
" 2 - open files in a new vertical split
" 3 - open files in a new tab
" 4 - open in previous window
let g:netrw_browse_split = 0
" new split is to the right:
let g:netrw_altv = 1
let g:netrw_winsize = 83

" }}}

""" Devicons --------------------------- {{{

let g:webdevicons_enable_ctrlp = 1

" }}}

""" Buffet ----------------------------- {{{

let g:buffet_powerline_separators = 0
let g:buffet_tab_icon = "\uf00a "
let g:buffet_left_trunc_icon = "\uf0a8"
let g:buffet_right_trunc_icon = "\uf0a9"

nmap <leader>1 <Plug>BuffetSwitch(1)
nmap <leader>2 <Plug>BuffetSwitch(2)
nmap <leader>3 <Plug>BuffetSwitch(3)
nmap <leader>4 <Plug>BuffetSwitch(4)
nmap <leader>5 <Plug>BuffetSwitch(5)
nmap <leader>6 <Plug>BuffetSwitch(6)
nmap <leader>7 <Plug>BuffetSwitch(7)
nmap <leader>8 <Plug>BuffetSwitch(8)
nmap <leader>9 <Plug>BuffetSwitch(9)
nmap <leader>0 <Plug>BuffetSwitch(10)

noremap <Tab>   :bn<CR>
noremap <S-Tab> :bp<CR>
noremap <Leader><Tab>   :Bw<CR>
noremap <Leader><S-Tab> :Bw!<CR>

noremap <C-t>     :tabnew<CR>
noremap :t<CR>    :tabnew<CR>
noremap :t<Space> :tabnew<Space>
" }}}

" vim:foldmethod=marker:foldlevel=0
