" Use vim settings, rather then vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible

"set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" turn on syntax highlighting
syntax on

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all 
" the plugins.
"let mapleader=","

" This loads all the plugins specified in ~/.vim/vundles.vim
" Use Vundle plugin to manage all other plugins
if filereadable(expand("~/.vim/vundles.vim"))
	source ~/.vim/vundles.vim
endif

" Turn off swap files.
set noswapfile
set nobackup
set nowb

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set list listchars=tab:\ \ ,trail:·

" Editing behaviour.
set nowrap			" Don't wrap lines.

"set shiftround
"set backspace=indent,eol,start	" Allow backspacing over everything in insert
				" mode.
"set autoindent			" Always set autoindenting on.
"set copyindent			" Copy the previous indentation on
				" autoindenting.
"set showmatch			" Set show matching parentheses.
"set ignorecase			" Ignore case when searching.
"set smartcase
"set hlsearch			" Highlight search terms.
"set incsearch			" Show search matches as you type.
"set gdefault			" Search/replace 'globally' (on a line) by
				" default.
"set listchars=tab:▸\ ,trail:·,extends:#,nbsp:·
"set nolist			" Don't show invisible characters by default
"set formatoptions+=1

"set termencoding=utf-8
"set encoding=utf-8
"set lazyredraw
"set laststatus=2
"set cmdheight=2

"set hidden
"set switchbuf=useopen

"set undodir=~/.vim/undo
"if exists('+undofile')
"	set undofile
"endif

"set nobackup
"set noswapfile
"set title
"set visualbell
"set noerrorbells
"set showcmd
"set nomodeline
"set cursorline

"set background=dark		" Assume a dark background
"set background=light		" Assume a light background
"set t_Co=256
"colorscheme solarized
"let g:Powerline_theme = 'solarized16'
"let g:Powerline_colorscheme = 'solarized'

"set shortmess+=I

"set backupcopy=yes		" Prevent Finder labels from disappearing
"set nobackup

" -- UI -----------------------------------------------------------------------

"set noshowmode			" don't display the current mode

"if has('statusline')
"  set laststatus=2
"endif

"set backspace=indent,eol,start	" backspace over everything in insert mode
"set showmatch			" show matching brackets/parentheses
"set incsearch			" do incremental searching
"set hlsearch
"set ignorecase			" case insensitive search
"set smartcase			" case sensitive search when uppercase present
"set wildmenu			" show list instead of just completing
"set wildmode=list:longest:full	" command <Tab> completion
"set wildignore=.*.bak,.*.tmp,*.pyc,*.swp
"set scrolloff=1			" minimum lines to keep above and below cursor

" -- FORMATTING ----------------------------------------------------------------

"set textwidth=79
"set wrap
"set showbreak=+

"set autoindent
"set smartindent

" Perl
"let perl_include_POD=1
"let perl_want_scope_in_variables=1
"let perl_extended_vars=1

" PHP
"let php_baselib=1
"let php_folding=1
"let php_htmlInStrings=1
"let php_noShortTags=1
"let php_sql_query=1

" Sed
"let highlight_sedtabs=1

" Shell
"let bash_is_sh=1		" highlight bash syntax
"let highlight_balanced_quotes=1	" highlight single quotes inside double
"let highlight_function_names=1

" -----------------------------------------------------------------------------

"set autoread			" reload changed files (if no local changes)
"set nobackup			" don't create backup files

" -----------------------------------------------------------------------------

"set spelllang=en_gb
"set spellfile=~/.vim/spell/en_gb.utf-8.add

"if has("autocmd") && exists("+omnifunc")
"	autocmd Filetype *
"		\ if &omnifunc == "" |
"		\   setlocal omnifunc=syntaxcomplete#Complete |
"		\ endif
"endif

" -----------------------------------------------------------------------------

"if filereadable(expand("~/.vimrc.local"))
"	source ~/.vimrc.local
"endif

" -- APPEARANCE

" Make it beautiful - colors and fonts

" http://ethanschoonover.com/solarized/vim-colors-solarized
colorscheme solarized
set background=dark

if has("gui_running")
  "tell the term has 256 colors
  set t_Co=256

  " Show tab number (useful for Cmd-1, Cmd-2.. mapping)
  " For some reason this doesn't work as a regular set command,
  " (the numbers don't show up) so I made it a VimEnter event
  autocmd VimEnter * set guitablabel=%N:\ %t\ %M

  set lines=60
  set columns=190

  set guifont=Inconsolata\ XL:h17,Inconsolata:h20,Monaco:h17
else
  "dont load csapprox if we no gui support - silences an annoying warning
  let g:CSApprox_loaded = 1
endif
