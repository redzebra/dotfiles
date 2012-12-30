#!/bin/sh -

POSIXLY_CORRECT=1
export POSIXLY_CORRECT

args=`getopt i: $*`
if [ $? != 0 ]; then
	echo "Usage: $0 [[-i identity_file] host ...]" >&2; exit 2
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

# Local install

umask 077 || exit

echo installing .local tree
for d in `find local -type d ! -name .git`; do
	_mkdir ~/.$d/
done
for f in `find local -type f ! -name '.git*'`; do
	case $f in
		local/bin/aws-context) ;;
		local/bin/*) _mode=0500;;
		local/etc/bash_completion.d/helpers/*) _mode=0500;;
	esac
	_install ${_mode:+-m ${_mode}} $f ~/.$f
	unset _mode
done
for f in `cd ~/.local && find * -type f`; do
	[ $f = 'share/autojump/autojump.txt' ] && continue
	[ -e local/$f ] || { echo removing ~/.local/$f; rm -f ~/.local/$f; }
done
if which SetFile >/dev/null 2>&1; then
	SetFile -a V ~/.local/
fi

if [ -d "/Applications/Sublime Text 2.app" ]; then
	echo installing Sublime Text 2 support
	_packages="${HOME}/Library/Application Support/Sublime Text 2/Packages"
	tar -C 'Sublime Text 2' -cf - --exclude '.git*' . | tar -C "${_packages}" -xf -
	unset _packages
fi

if which perl >/dev/null 2>&1; then
	echo installing ack support
	_install ackrc ~/.ackrc
fi

if which bash >/dev/null 2>&1; then
	echo installing bash support
	for f in bash_completion bash_logout bash_profile bashrc; do
		_install $f ~/.$f
	done
	_mkdir ~/.bash_completion.d
	for f in bash_completion.d/*; do
		[ -f $f ] && _install $f ~/.$f
	done
	for f in `cd ~/.bash_completion.d && find * -type f`; do
		[ -e bash_completion.d/$f ] || { echo removing ~/.bash_completion.d/$f; rm -f ~/.bash_completion.d/$f; }
	done
	_install inputrc ~/.inputrc
fi

if [ -z "${variant}" ] && which git >/dev/null 2>&1; then
	echo installing git support
	for f in gitconfig gitignore; do _install $f ~/.$f; done
fi

if [ `uname -s` = Darwin -o `uname -s` = Linux ]; then
	echo installing colordiff support
	_install colordiffrc ~/.colordiffrc
fi

if which hg >/dev/null 2>&1; then
	echo installing mercurial support
	_install -m 0400 hgignore ~/.hgignore
	_install -m 0400 hgrc ~/.hgrc
fi

if which puppet-lint >/dev/null 2>&1; then
	echo installing puppet-lint support
	rm -fv ~/.puppet-lintrc
	_install -m 0400 puppet-lint.rc ~/.puppet-lint.rc
fi

if [ `uname -s` = Darwin ]; then
	echo installing python support
	_install pydistutils.cfg ~/.pydistutils.cfg
fi

if which ruby >/dev/null 2>&1; then
	echo installing ruby support
	_mkdir ~/.gem/
	_install gemrc ~/.gemrc
	_install irbrc ~/.irbrc
	_install rspec ~/.rspec
fi

if which screen >/dev/null 2>&1; then
	echo installing screen support
	_install -m 0400 screenrc ~/.screenrc
fi

if which ssh >/dev/null 2>&1; then
	echo installing ssh support
	_mkdir ~/.ssh/
fi

if which svn >/dev/null 2>&1; then
	echo installing subversion support
	_mkdir ~/.subversion/
	_install subversion/config ~/.subversion/config
	_install colorsvnrc ~/.colorsvnrc
fi

if [ `uname -s` = OpenBSD ]; then
	echo installing vi support
	_install nexrc ~/.nexrc
fi

if which vim >/dev/null 2>&1; then
	echo installing vim support
	for d in `find vim -type d ! -name .git`; do
		_mkdir ~/.$d/
	done
	_mkdir ~/.vim/view/
	for f in `find vim -type f ! -name '.git*'`; do
		_install $f ~/.$f
	done
	for f in `cd ~/.vim && find * -type f ! -name tags ! -name '*.cache' ! -name '*.spl'|egrep -v '^view/'`; do
		[ -e vim/$f ] || { echo removing ~/.vim/$f; rm -f ~/.vim/$f; }
	done
	_install vimrc ~/.vimrc
	if which gvim >/dev/null 2>&1 || which mvim >/dev/null 2>&1; then
		_install gvimrc ~/.gvimrc
	fi
 	[ -d ~/.vim/doc ] && vim -E -i NONE -u NONE '+helptags ~/.vim/doc' '+quit' </dev/null >/dev/null
	for d in ~/.vim/bundle/*/doc; do
	 	vim -E -i NONE -u NONE "+helptags $d" '+quit' </dev/null >/dev/null
	done
	for f in ~/.vim/spell/*.add; do
		vim -E -i NONE -u NONE "+mkspell! $f" '+quit' </dev/null >/dev/null
	done
fi

# vi: set sw=2 ts=2:
