" -----------------------------------------------------------------------------
"  ENVIRONMENT
" -----------------------------------------------------------------------------

set nocompatible                " Must be first
scriptencoding utf-8

" -----------------------------------------------------------------------------
"  GENERAL
" -----------------------------------------------------------------------------

set runtimepath+=~/.vim/bundle/pathogen
call pathogen#infect()

syntax on			" Turn on syntax highlighting
filetype plugin indent on	" Automatically detect file types

set background=dark		" Assume a dark background
colorscheme ir_black

set nobackup

" -----------------------------------------------------------------------------
"  UI
" -----------------------------------------------------------------------------

if has('statusline')
	set laststatus=2
endif

" -----------------------------------------------------------------------------
"  FORMATTING
" -----------------------------------------------------------------------------

set wrap
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

if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
endif

" -----------------------------------------------------------------------------
