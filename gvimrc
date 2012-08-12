set columns=88
set guifont=Monaco:h13
set guioptions-=T	" Hide the toolbar
set lines=40
set showtabline=2	" Always show tabs

if $TERM_PROGRAM == "Apple_Terminal"
	autocmd VimLeave * !open -a Terminal
endif
