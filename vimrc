" Use vim settings, rather then vi settings (much better!)
" This must be first, because it changes other options as a side effect.
set nocompatible

set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

if filereadable(expand("~/.vimrc.before"))
  source ~/.vimrc.before
endif

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

" Change leader to a comma because the backslash is too far away.
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all the plugins.
let mapleader=","

" This loads all the plugins specified in ~/.vim/vundles.vim
" Use Vundle plugin to manage all other plugins.
if filereadable(expand("~/.vim/vundles.vim"))
	source ~/.vim/vundles.vim
endif

" Turn off swap files.
set noswapfile
set nobackup
set nowb

silent !mkdir ~/.vim/undo >/dev/null 2>&1
set undodir=~/.vim/undo
if exists('+undofile')
	set undofile
endif

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually.
set list listchars=tab:\ \ ,trail:·

" Editing behaviour.
set nowrap			                " don't wrap lines
set linebreak                   " wrap lines at convenient points

set foldmethod=indent
set foldnestmax=3
set nofoldenable                " don't fold by default

set wildmode=list:longest
set wildmenu
set wildignore=*~,*.o,*.obj,*.pyc,*.swp
set wildignore+=.DS_Store
set wildignore+=~/.vim/undo

set scrolloff=8
set sidescrolloff=15
set sidescroll=1

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

set spelllang=en_gb
set spellfile=~/.vim/spell/en_gb.utf-8.add

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

"  set lines=60
"  set columns=190

"  set guifont=Inconsolata\ XL:h17,Inconsolata:h20,Monaco:h17
else
  "dont load csapprox if we no gui support - silences an annoying warning
  let g:CSApprox_loaded=1
endif

" -- APPEND-SEMICOLON

" If there isn't one, append a semicolon to the end of the current line.
function! s:appendSemiColon()
  if getline('.') !~ ';$'
    let original_cursor_position = getpos('.')
    exec("s/$/;/")
    call setpos('.', original_cursor_position)
  endif
endfunction
" For programming languages using a semicolon at the end of statement.
autocmd FileType c,cpp,css,jade,java,javascript,perl,php nmap <silent> ;; :call <SID>appendSemiColon()<CR>
autocmd FileType c,cpp,css,jade,java,javascript,perl,php inoremap <silent> ;; <ESC>:call <SID>appendSemiColon()<CR>a

" -- WHITESPACE-KILLER

" via: http://rails-bestpractices.com/posts/60-remove-trailing-whitespace
" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l=line(".")
  let c=col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction
command! StripTrailingWhitespaces call <SID>StripTrailingWhitespaces()
nmap ,w :StripTrailingWhitespaces<CR>

" -- WRAPPING

" http://vimcasts.org/episodes/soft-wrapping-text/
function! SetupWrapping()
  set wrap linebreak nolist
  set showbreak=…
endfunction

" TODO: this should happen automatically for certain file types (e.g.
" markdown)
command! -nargs=* Wrap :call SetupWrapping()<CR>
