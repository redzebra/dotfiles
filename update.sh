#!/bin/bash

_fetch () {
	local dst="$1"
	local src="$2"
	echo "- ${dst}"
	[ -d `dirname "${dst}"` ] || mkdir -v `dirname "${dst}"`
	curl -o "${dst}" -RsS "${src}"
	case "${dst}" in
		*.zip) unzip -oq "${dst}" -d `dirname "${dst}"`; rm "${dst}";;
		*) git add "${dst}";;
	esac
}

git submodule update

# ack
_fetch bash_completion.d/ack \
	https://raw.github.com/petdance/ack/master/etc/ack.bash_completion.sh
_fetch local/bin/ack \
	https://raw.github.com/petdance/ack/master/ack

# autojump
#_fetch bash_completion.d/autojump \
#	https://raw.github.com/joelthelion/autojump/master/bin/autojump.bash
#_fetch local/bin/autojump \
#	https://raw.github.com/joelthelion/autojump/master/bin/autojump
#_fetch local/share/man/man1/autojump.1 \
#	https://raw.github.com/joelthelion/autojump/master/docs/autojump.1

# colordiff
_fetch local/bin/colordiff \
	https://raw.github.com/daveewart/colordiff/master/colordiff.pl

# vim
_fetch vim/colors/molokai.vim \
	https://raw.github.com/tomasr/molokai/master/colors/molokai.vim
_fetch vim/plugin/autotag.vim \
	https://raw.github.com/craigemery/dotFiles/master/vim/plugin/autotag.vim
_fetch vim/plugin/openssl.vim \
	'http://www.vim.org/scripts/download_script.php?src_id=8564'
_fetch vim/syntax/haproxy.vim \
	'http://www.vim.org/scripts/download_script.php?src_id=6924'
_fetch vim/syntax/interfaces.vim \
	'http://www.vim.org/scripts/download_script.php?src_id=4693'
_fetch vim/syntax/json.vim \
	'http://www.vim.org/scripts/download_script.php?src_id=10853'
