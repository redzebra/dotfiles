#export ZDOTDIR="$HOME/.dotfiles"

#export EDITOR='vim'
#export VISUAL='vim'
#export PAGER='less'

#if [[ -z "$LANG" ]]; then
#	eval "$(locale)"
#fi

#typeset -gU cdpath fpath mailpath path

#cdpath=(
#	$cdpath
#)

path=(
	/usr/local/{bin,sbin}
	$path
)

env=$HOME/.zsh/env
if [ -f $env/*([1]) ]; then
	for script in $env/*; do
		source $script
	done
fi
