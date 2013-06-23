filetype off			" required!

set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle (required)
Bundle "gmarik/vundle"

" Ruby, Rake, etc.
Bundle 'tpope/vim-rake'
Bundle 'tpope/vim-rbenv'
Bundle 'vim-ruby/vim-ruby'

" Other languages
Bundle 'briancollins/vim-jst'
Bundle 'pangloss/vim-javascript'
Bundle 'redzebra/vim-puppet'

" HTML, XML, CSS, Markdown, etc.
Bundle 'jtratner/vim-flavored-markdown'
Bundle 'kchmck/vim-coffee-script'
Bundle 'tpope/vim-haml'

" Git related
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'

" General text editing improvements
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-bundler'

" General Vim improvements
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-endwise'
"Bundle 'vim-scripts/sudo'

" Text objects
Bundle 'nathanaelkane/vim-indent-guides'

" Cosmetics, color scheme, Powerline...
Bundle 'Lokaltog/powerline'
Bundle 'bogado/file-line'
Bundle 'chrisbra/color_highlight'
Bundle 'itspriddle/vim-jquery'
Bundle 'skwp/vim-colors-solarized'
"Bundle 'skwp/vim-powerline'
Bundle 'vim-scripts/TagHighlight'

"Bundle 'bitc/vim-bad-whitespace'
"Bundle 'editorconfig/editorconfig-vim'
"Bundle 'elzr/vim-json'
"Bundle 'jamessan/vim-gnupg'

" Local customization
if filereadable(expand("~/.vim/vundles.local.vim"))
  source ~/.vim/vundles.local.vim
endif

" Filetype plugin indent on is required by vundle
filetype plugin indent on           
