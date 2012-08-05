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

# colordiff
_fetch local/bin/colordiff \
	https://raw.github.com/daveewart/colordiff/master/colordiff.pl

# vim
_fetch vim/colors/molokai.vim \
	https://raw.github.com/tomasr/molokai/master/colors/molokai.vim
_fetch vim/plugin/openssl.vim \
	'http://www.vim.org/scripts/download_script.php?src_id=8564'
_fetch vim/syntax/haproxy.vim \
	'http://www.vim.org/scripts/download_script.php?src_id=6924'
_fetch vim/syntax/interfaces.vim \
	'http://www.vim.org/scripts/download_script.php?src_id=4693'
_fetch vim/syntax/json.vim \
	'http://www.vim.org/scripts/download_script.php?src_id=10853'
