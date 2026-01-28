" =============================================================================
" .vimrc - Minimal Server Configuration
" =============================================================================
" Designed for quick edits on servers. No plugins, no heavy features.
"
" Structure:
"   1. General settings
"   2. Display
"   3. Search
"   4. Indentation
"   5. Files
"   6. Key bindings
"   7. Colors
"
" Leader key: Space
" =============================================================================

" Disable vi compatibility (enable vim features)
set nocompatible

" =============================================================================
" General
" =============================================================================
set encoding=utf-8
set fileencoding=utf-8
set backspace=indent,eol,start    " Backspace works across lines
set hidden                        " Allow switching buffers without saving
set autoread                      " Reload files changed outside vim
set history=1000                  " Command history
set undolevels=1000               " Undo history

" =============================================================================
" Display
" =============================================================================
syntax on                         " Syntax highlighting
set number                        " Show line numbers
set relativenumber                " Relative line numbers (easier jumps)
set ruler                         " Show cursor position in status line
set showcmd                       " Show partial commands in status line
set showmode                      " Show current mode (INSERT, VISUAL, etc.)
set laststatus=2                  " Always show status line
set scrolloff=5                   " Keep 5 lines visible above/below cursor
set sidescrolloff=5               " Keep 5 columns visible left/right
set display+=lastline             " Show as much as possible of wrapped lines
set nowrap                        " Don't wrap long lines
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+

" =============================================================================
" Search
" =============================================================================
set incsearch                     " Search as you type
set hlsearch                      " Highlight all matches
set ignorecase                    " Case-insensitive search
set smartcase                     " Unless search contains uppercase

" =============================================================================
" Indentation
" =============================================================================
set autoindent                    " Copy indent from current line
set smartindent                   " Smart indent for C-like languages
set expandtab                     " Use spaces instead of tabs
set tabstop=4                     " Tab = 4 spaces
set shiftwidth=4                  " Indent = 4 spaces
set softtabstop=4                 " Backspace deletes 4 spaces

" =============================================================================
" Files
" =============================================================================
set nobackup                      " Don't create backup files
set nowritebackup                 " Don't create backup before overwriting
set noswapfile                    " Don't create swap files
filetype plugin indent on         " Enable filetype detection and plugins

" =============================================================================
" Key Bindings
" =============================================================================
" Leader key (Space is easy to reach)
let mapleader = " "

" Clear search highlight with Space+Space
nnoremap <leader><space> :nohlsearch<CR>

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Window navigation with Ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Move lines up/down with Alt+j/k
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Stay in visual mode when indenting
vnoremap < <gv
vnoremap > >gv

" Y yanks to end of line (consistent with D, C behavior)
nnoremap Y y$

" =============================================================================
" Colors
" =============================================================================
set background=dark

" Use desert colorscheme if terminal supports enough colors
if &t_Co >= 256 || has("gui_running")
    colorscheme desert
endif

" Simple status line: filename [modified] [readonly]  line/total col percentage
set statusline=%f\ %m%r%h%w%=%l/%L\ %c\ %p%%
