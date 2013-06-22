#!/bin/sh -

POSIXLY_CORRECT=1
export POSIXLY_CORRECT

args=`getopt i: $*`
if [ $? != 0 ]; then
uecho "Usage: $0 [[-i identity_file] host ...]" >&2; exit 2
fi
set -- $args
for i; do
	case "$i" in
		-i) identity_file=$2; shift 2;;
		--) shift; break;;
	esac
done
if [ -n "$identity_file" -a $# = 0 ]; then
	echo "Usage: $0 [[-i identity_file] host ...]" >&2; exit 2
fi

if [ `id -u` = 0 ]; then
	echo "$0: refusing to run as root" >&2; exit 1
fi

cd `dirname $0` || exit

# Sanity checks.

if which bash >/dev/null 2>&1; then
	for f in bash_completion bash_logout bash_profile bashrc; do
		bash -n $f || exit
	done
fi

if test -d .git && which git >/dev/null 2>&1; then
	_status=`git status -s`
	if [ -n "$_status" ]; then
		git status -s
	fi
	unset _status
fi

# Remote install.

if [ $# != 0 ]; then
	if [ ! -d .tools ]; then
		echo "$0: .tools directory missing?" >&2; exit 1
	fi
	ssh="ssh -akqTx -e none ${identity_file+-i $identity_file}"
	shar="`./.tools/shar $(find . -name '.?*' -prune -o -print)`" || exit
	workdir=dotfiles.`date +%s`
	for host; do
		echo "---- $host ----"
		$ssh $host sh - <<__END__ || exit
mkdir -m 0700 ~/$workdir || exit
cd ~/$workdir && sh <<'__SHAR__' >/dev/null && sh install.sh
$shar
__SHAR__
cd ~ && rm -rf $workdir
__END__
	done
	exit
fi

# Local install helpers.

_mkdir () {
	local _args _d _i
	_args=`getopt m: "$@"`
	if [ $? != 0 ]; then
		echo "Usage: ${FUNCNAME[0]} [-m mode] directory ..." >&2; __args; return 1
	fi
	set -- $_args
	for _i; do
		case "$_i" in
			-m) _mode="$2"; shift 2;;
			--) shift; break;;
		esac
	done
	if [ $# = 0 ]; then
		echo "Usage: ${FUNCNAME[0]} [-m mode] directory ..." >&2; return 1
	fi
	for _d in "$@"; do
		[ -d "$_d" ] || mkdir "$_d" || return
	done
	chmod ${_mode:-0700} "$@" || return
}

_install () {
  local _args _i _mode _src
  _args=`getopt m: "$@"`
  if [ $? != 0 ]; then
    echo "Usage: ${FUNCNAME[0]} [-m mode] file1 file2" >&2; return 1
  fi
  set -- $_args
  for _i; do
    case "$_i" in
      -m) _mode="$2"; shift 2;;
      --) shift; break;;
    esac
  done
  if [ $# != 2 ]; then
    echo "Usage: ${FUNCNAME[0]} [-m mode] file1 file2" >&2; return 1
  fi
  [ -n "$variant" -a -e "$1.$variant" ] && _src="$1.$variant"
  cmp -s "${_src:-$1}" "$2" || cp -fv "${_src:-$1}" "$2" || return
  chmod ${_mode:-0400} "$2" || return
}

_git_clone () {
	if [ -d $2/.git ]; then
		(cd $2 && git pull -q)
	else
		git clone -q --depth 1 --recursive -- $1 $2
	fi
}

_ln_s () {
	if [ $# != 1 ]; then
		echo "Usage: ${FUNCNAME[0]} source_file" >&2; return 1
	fi
	[ "`readlink ~/.$1`" = ".dotfiles/$1" ] && return
	ln -hfsv .dotfiles/$1 ~/.$1
}

# Local install

umask 077 || exit

echo installing .local tree
_ln_s local
if which SetFile >/dev/null 2>&1; then
	SetFile -P -a V ~/.local
fi

#defaults write com.apple.terminal 'Window Settings' -dict-add \
#	IR_Black "`cat Terminal/IR_Black.terminal`"
#defaults write com.apple.terminal 'Default Window Settings' IR_Black
#defaults write com.apple.terminal 'Startup Window Settings' IR_Black

echo installing ack support
_ln_s ackrc

echo installing bash support
_ln_s bash_completion
_ln_s bash_completion.d
_ln_s bash_logout
_ln_s bash_profile
_ln_s bashrc
_ln_s inputrc

echo installing ctags support
_ln_s ctags

echo installing git support
_ln_s gitconfig
[ -e ~/.gitconfig.user ] || touch ~/.gitconfig.user

echo installing colordiff support
_ln_s colordiffrc

echo installing puppet-lint support
_ln_s puppet-lint.rc
rm -fv ~/.puppet-lintrc

echo installing rbenv
_git_clone https://github.com/sstephenson/rbenv.git ~/.rbenv
_git_clone https://github.com/tpope/rbenv-ctags.git \
	~/.rbenv/plugins/rbenv-ctags
_git_clone https://github.com/sstephenson/rbenv-default-gems.git \
	~/.rbenv/plugins/rbenv-default-gems
_git_clone https://github.com/chriseppstein/rbenv-each.git \
	~/.rbenv/plugins/rbenv-each
_git_clone https://github.com/sstephenson/rbenv-gem-rehash.git \
	~/.rbenv/plugins/rbenv-gem-rehash
_git_clone https://github.com/rkh/rbenv-update.git \
	~/.rbenv/plugins/rbenv-update
_git_clone https://github.com/sstephenson/rbenv-vars.git \
	~/.rbenv/plugins/rbenv-vars
_git_clone https://github.com/sstephenson/ruby-build.git \
	~/.rbenv/plugins/ruby-build
#_ln_s rbenv/default-gems
[ "`readlink ~/.rbenv/default-gems`" = "../.dotfiles/rbenv/default-gems" ] || {
	ln -hfsv ../.dotfiles/rbenv/default-gems ~/.rbenv/default-gems
}
ln -hfsv ../../.dotfiles/rbenv/bin/rbenv-auto-ruby ~/.rbenv/bin/

echo installing ruby support
_ln_s gemrc
_ln_s irbrc
_ln_s pryrc
_ln_s rspec

#if which screen >/dev/null 2>&1; then
#	echo installing screen support
#	_install -m 0400 screenrc ~/.screenrc
#fi

echo installing ssh support
_mkdir ~/.ssh/

#if which svn >/dev/null 2>&1; then
#	echo installing subversion support
#	_mkdir ~/.subversion/
#	_install subversion/config ~/.subversion/config
#	_install colorsvnrc ~/.colorsvnrc
#fi

echo installing vim support
_ln_s gvimrc
_ln_s vim
_ln_s vimrc
_mkdir ~/.vim/undo/
vim --noplugin -u vim/vundles.vim -N '+set hidden' '+syntax on' +BundleClean! +BundleInstall +qall

#	_mkdir ~/.vim/view/
#	for f in `find vim -type f ! -name '.git*'`; do
#		_install $f ~/.$f
#	done
#	for f in `cd ~/.vim && find * -type f ! -name tags ! -name '*.cache' ! -name '*.spl'|egrep -v '^view/'`; do
#		[ -e vim/$f ] || { echo removing ~/.vim/$f; rm -f ~/.vim/$f; }
#	done
#	if which gvim >/dev/null 2>&1 || which mvim >/dev/null 2>&1; then
#		_install gvimrc ~/.gvimrc
#	fi
# 	[ -d ~/.vim/doc ] && vim -E -i NONE -u NONE '+helptags ~/.vim/doc' '+quit' </dev/null >/dev/null
#	for d in ~/.vim/bundle/*/doc; do
#	 	vim -E -i NONE -u NONE "+helptags $d" '+quit' </dev/null >/dev/null
#	done
#	for f in ~/.vim/spell/*.add; do
#		vim -E -i NONE -u NONE "+mkspell! $f" '+quit' </dev/null >/dev/null
#	done
#fi

[ -d '/Applications/Sublime Text 2.app' ] && (
	echo installing Sublime Text 2 support
	(
		cd "${HOME}/Library/Application Support/Sublime Text 2/Installed Packages"
		[ -e "Package Control.sublime-package" ] || {
			curl --fail -# -o 'Package Control.sublime-package' \
				'https://sublime.wbond.net/Package%20Control.sublime-package'
		}
	)
	tar -C "Sublime Text" -cf - 'Packages/User' \
		| tar -C "${HOME}/Library/Application Support/Sublime Text 2" -xf -
)

[ -d '/Applications/Sublime Text.app' ] && (
	echo installing Sublime Text 3 support
	(
		cd "${HOME}/Library/Application Support/Sublime Text 3/Packages"
		[ -d "Package Control" ] || {
			git clone --branch python3 --depth 1 --single-branch -- \
				https://github.com/wbond/sublime_package_control.git \
				"Package Control"
		}
	)
	tar -C "Sublime Text" -cf - 'Packages/User' \
		| tar -C "${HOME}/Library/Application Support/Sublime Text 3" -xf -
)

mkdir -p local/lib/python2.7
PYTHONPATH=${PYTHONPATH}:${PWD}/local/lib/python2.7 easy_install-2.7 --install-dir=${PWD}/local/lib/python2.7 awscli #--script-dir=${PWD}/local/bin awscli

# vi: set sw=2 ts=2:
