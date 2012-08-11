" -- ENVIRONMENT --------------------------------------------------------------

set nocompatible                " Must be first
scriptencoding utf-8

" -- GENERAL ------------------------------------------------------------------

runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

syntax on			" Turn on syntax highlighting
filetype plugin indent on	" Automatically detect file types

set background=dark		" Assume a dark background
colorscheme ir_black

set shortmess+=I

set backupcopy=yes		" Prevent Finder labels from disappearing
set nobackup

" -- UI -----------------------------------------------------------------------

set noshowmode			" don't display the current mode

if has('statusline')
	set laststatus=2
endif

set backspace=indent,eol,start	" backspace over everything in insert mode
set showmatch			" show matching brackets/parentheses
set incsearch			" do incremental searching
set hlsearch
set ignorecase			" case insensitive search
set smartcase			" case sensitive search when uppercase present
set wildmenu			" show list instead of just completing
set wildmode=list:longest:full	" command <Tab> completion
set wildignore=.*.bak,.*.tmp,*.pyc,*.swp
set scrolloff=3			" minimum lines to keep above and below cursor

" -- FORMATTING ----------------------------------------------------------------

set textwidth=79
"set wrap
"set showbreak=+

set autoindent
set smartindent

" Perl
let perl_include_POD=1
let perl_want_scope_in_variables=1
let perl_extended_vars=1

" PHP
let php_baselib=1
let php_folding=1
let php_htmlInStrings=1
let php_noShortTags=1
let php_sql_query=1

" Sed
let highlight_sedtabs=1

" Shell
let bash_is_sh=1		" highlight bash syntax
let highlight_balanced_quotes=1	" highlight single quotes inside double
let highlight_function_names=1

" -----------------------------------------------------------------------------

set autoread			" reload changed files (if no local changes)
set nobackup			" don't create backup files

" -----------------------------------------------------------------------------

set spelllang=en_gb
set spellfile=~/.vim/spell/en_gb.utf-8.add

" -----------------------------------------------------------------------------

if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
endif

" -----------------------------------------------------------------------------
