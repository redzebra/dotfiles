" Use vim settings, rather then vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible

" Use pathogen to easily modify the runtime path to include all plugins under
" the ~/.vim/bundle directory.
filetype off			" Force reloading after pathogen is loaded
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
"call pathogen#helptags()
filetype plugin indent on	" Automatically detect file types
syntax on			" Turn on syntax highlighting

" Editing behaviour.
"set showmode
set nowrap			" Don't wrap lines.
set shiftround
set backspace=indent,eol,start	" Allow backspacing over everything in insert
				" mode.
set autoindent			" Always set autoindenting on.
set copyindent			" Copy the previous indentation on
				" autoindenting.
set showmatch			" Set show matching parentheses.
set ignorecase			" Ignore case when searching.
set smartcase
set hlsearch			" Highlight search terms.
set incsearch			" Show search matches as you type.
set gdefault			" Search/replace 'globally' (on a line) by
				" default.
set listchars=tab:▸\ ,trail:·,extends:#,nbsp:·
set nolist			" Don't show invisible characters by default
set formatoptions+=1

set termencoding=utf-8
set encoding=utf-8
set lazyredraw
set laststatus=2
set cmdheight=2

set hidden
set switchbuf=useopen

set undodir=~/.vim/undo
if exists('+undofile')
	set undofile
endif

set nobackup
set noswapfile
set title
set visualbell
set noerrorbells
set showcmd
set nomodeline
set cursorline

set background=dark		" Assume a dark background
"set background=light		" Assume a light background
set t_Co=256
colorscheme solarized
"let g:Powerline_theme = 'solarized16'
let g:Powerline_colorscheme = 'solarized'

set shortmess+=I

set backupcopy=yes		" Prevent Finder labels from disappearing
set nobackup

" -- UI -----------------------------------------------------------------------

"set noshowmode			" don't display the current mode

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
set scrolloff=1			" minimum lines to keep above and below cursor

" -- FORMATTING ----------------------------------------------------------------

"set textwidth=79
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

set autoread			" reload changed files (if no local changes)
set nobackup			" don't create backup files

" -----------------------------------------------------------------------------

set spelllang=en_gb
set spellfile=~/.vim/spell/en_gb.utf-8.add

if has("autocmd") && exists("+omnifunc")
	autocmd Filetype *
		\ if &omnifunc == "" |
		\   setlocal omnifunc=syntaxcomplete#Complete |
		\ endif
endif

" -----------------------------------------------------------------------------

if filereadable(expand("~/.vimrc.local"))
	source ~/.vimrc.local
endif

" -----------------------------------------------------------------------------
