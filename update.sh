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

_fetch bash_completion.d/ack \
	https://raw.github.com/petdance/ack/master/etc/ack.bash_completion.sh
_fetch local/bin/ack \
	https://raw.github.com/petdance/ack/master/ack

# Sublime Text 2 - Themes - IR_black
#_fetch 'Sublime Text 2/Packages/Color Scheme - Default/IR_Black.tmTheme' \
#	http://sublime-text-community-packages.googlecode.com/svn/trunk/Themes/IR_Black.tmTheme

# vim - fugitive
#_fetch vim/fugitive.zip \
#	'http://www.vim.org/scripts/download_script.php?src_id=15542'

# vim - haproxy
#_fetch vim/syntax/haproxy.vim \
#	'http://www.vim.org/scripts/download_script.php?src_id=6924'

# vim - interfaces
#_fetch vim/syntax/interfaces.vim \
#	'http://www.vim.org/scripts/download_script.php?src_id=4693'

# vim - ir_black
#_fetch vim/colors/ir_black.vim \
#	'http://blog.toddwerth.com/entry_files/8/ir_black.vim'

# vim - json
#_fetch vim/syntax/json.vim \
#	'http://www.vim.org/scripts/download_script.php?src_id=10853'

# vim - markdown
#for f in ftdetect/markdown.vim syntax/markdown.vim; do
#	_fetch vim/$f https://raw.github.com/hallison/vim-markdown/master/$f
#done

# vim - openssl
#_fetch vim/ftplugin/openssl.vim \
#	'http://www.vim.org/scripts/download_script.php?src_id=8564'

## vim - pathogen
#_fetch vim/autoload/pathogen.vim \
#	https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

# vim - puppet
#for f in ftplugin/puppet.vim indent/puppet.vim syntax/puppet.vim; do
#	_fetch vim/$f https://raw.github.com/puppetlabs/puppet-syntax-vim/master/$f
#done

# vim - solarized
#_fetch vim/colors/solarized.vim \
#	https://raw.github.com/altercation/vim-colors-solarized/master/colors/solarized.vim

# vim - syntastic
#_fetch vim/syntastic.zip \
#  'http://www.vim.org/scripts/download_script.php?src_id=17114'
