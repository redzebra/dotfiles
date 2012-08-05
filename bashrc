# .bashrc file for interactive bash(1) shells.

if [ -z "${PS1}" ]; then
	return
fi

shopt -u cdable_vars 2>/dev/null
shopt -s cdspell 2>/dev/null
shopt -s checkhash 2>/dev/null
shopt -s checkwinsize 2>/dev/null
shopt -s cmdhist 2>/dev/null
shopt -s extglob 2>/dev/null
shopt -s histappend 2>/dev/null
shopt -s hostexpand 2>/dev/null
shopt -u mailwarn 2>/dev/null
shopt -s no_empty_cmd_completion 2>/dev/null
shopt -s promptvars 2>/dev/null
shopt -s xpg_echo 2>/dev/null

for d in /opt/bin /opt/local/bin /opt/aws/bin; do
	[ -d "${d}" ] && PATH="${d}:${PATH}"
done
for d in "${HOME}/.local/bin" "${HOME}/.gem/ruby/1.8/bin" "${HOME}/bin"; do
	[ -d "${d}" ] && PATH="${d}:${PATH}"
done

for d in "/opt/bash/share/man"; do
	[ -d "${d}" ] && MANPATH="${d}:${MANPATH:+:${MANPATH}}"
done
for d in "${HOME}/.local/share/man"; do
	[ -d "${d}" ] && MANPATH="${d}${MANPATH:+:${MANPATH}}"
done

for d in "${HOME}/lib/python2.7/site-packages"; do
	[ -d "${d}" ] && export PYTHONPATH="${d}"
done

: ${HISTCONTROL:='ignorespace:erasedups'}
: ${HISTIGNORE:='&:bg:exit:fg:ls'}
: ${HISTSIZE:=1000}
export HISTCONTROL HISTIGNORE HISTSIZE

export CLICOLOR=1

if which vim >/dev/null 2>&1; then
	export VISUAL=vim
elif which vi >/dev/null 2>&1; then
	export VISUAL=vi
fi

OS=$(uname -s)
if [[ ${OS} = Darwin ]]; then
	if [[ -n "${LANG}" && -z "${LC_ALL}" ]]; then
		export LC_ALL="${LANG}"
	fi
elif [[ ${OS} = Linux ]]; then
	if _lsb_release=$(command -pv lsb_release); then
		OS=$(${_lsb_release} -i -s)
		unset _lsb_release
	elif [[ -e /etc/debian_version ]]; then
		OS=Debian
	elif [[ -e /etc/redhat-release ]]; then
		if grep -i CentOS /etc/redhat-release >/dev/null; then
			OS=CentOS
		else
			OS=RedHat
		fi
	fi
fi

# -- Fancy Prompt -------------------------------------------------------------

DEFAULT=$'\e0m'

BLACK=$'\e0;30m'
RED=$'\e0;31m'
GREEN=$'\e32m'
YELLOW=$'\e0;33m'
BLUE=$'\e0;34m'
PURPLE=$'\e0;35m'
CYAN=$'\e0;36m'
LIGHTGRAY=$'\e0;37m'

#PINK=$'\e[35;40m'
#GREEN=$'\e[32;40m'
#ORANGE=$'\e[33;40m'

function scm_ps1 () {
	if [[ -d .svn ]]; then
		which svnversion &>/dev/null && echo -n "($(svnversion 2>/dev/null))"
	elif [[ $(declare -f __git_ps1) ]]; then
		local GIT_PS1_SHOWDIRTYSTATE=yes
		local GIT_PS1_SHOWSTASHSTATE=yes
		local GIT_PS1_SHOWUNTRACKEDFILES=yes
		local GIT_PS1_SHOWUPSTREAM='auto verbose'
		echo -n "$(__git_ps1 '(%s)' 2>/dev/null)"
	fi
}

case $(hostname -s) in
	domU-*-*-*-*|ec2-*-*-*-*|ip-*-*-*-*)
		if which curl &>/dev/null; then
			_id="$(curl -s http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)"
		elif which wget &>/dev/null; then
			_id="$(wget -o - -q http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null)"
		fi
		if which facter &>/dev/null; then
			if [[ -z "${_id}" ]]; then
				_id="$(facter ec2_instance_id 2>/dev/null)"
			fi
			_role="$(facter role 2>/dev/null)"	# GNM
			_stage="$(facter stage 2>/dev/null)"	# GNM
		fi
		if [[ -n "${_stage}" ]]; then
			case "${_stage}" in
				PROD) _stage='\[\e[1;31m\]'${_stage}':';;
				*)    _stage="${_stage}:"
			esac
		fi
		if [[ -n "${_role}" ]]; then
			_role="${_role}:"
		fi
		_hostid="${_stage}${_role}${_id:-[EC2]}"
#		PS1='\[\e[1;32m\]'${_stage}${_role}${_id:-[EC2]}'\[\e[0m\]:\[\e[1;34m\]\W\[\e[0m\]$(scm_ps1)\[\e[0m\]\$ '
		unset _id
		;;
	*)
		_hostid='$(tr "[A-Z]" "[a-z]" <<<\h)'
esac
PS1='\[\e[1;32m\]'${_hostid}'\[\e[0m\]:\[\e[1;34m\]\W\[\e[0m\]$(scm_ps1)\[\e[0m\]\$ '
export PS1

#export PS1='\n${PINK}\u \
#${DEFAULT}at ${ORANGE}\h \
#${DEFAULT}in ${GREEN}\w\
#$(scm_ps1)${GREEN}$(hg_dirty)\
#${DEFAULT}\n\$ '

# -- Ubuntu Annoyances --------------------------------------------------------

if [[ ${OS} = Ubuntu ]]; then
	if [[ ! -e $HOME/.sudo_as_admin_successful ]]; then
		case " $(groups) " in "* admin *")
			echo touch $HOME/.sudo_as_admin_successful
		esac
	fi
	unset -f command_not_found_handle
fi

# -- grep ---------------------------------------------------------------------

[[ -z "${GREP_OPTIONS}" ]] && {
	if echo foo|grep --color=auto foo - &>/dev/null; then
		GREP_OPTIONS+="${GREP_OPTIONS:+ }--color=auto"
	fi
	if echo foo|grep --exclude-dir=bar foo - &>/dev/null; then
		GREP_OPTIONS+="${GREP_OPTIONS:+ }--exclude-dir=.git --exclude-dir=.svn"
	fi
	[[ -n "${GREP_OPTIONS}" ]] && export GREP_OPTIONS
}

# -- less ---------------------------------------------------------------------

if command -v less &>/dev/null; then
	#[[ -z "${LESS}" ]] && export LESS="-R"
	[[ -z "${LESSHISTFILE}" ]] && LESSHISTFILE=/dev/null

	[[ -z "${LESSOPEN}" ]] && {
		for _p in lesspipe lesspipe.sh; do
			if command -v ${_p} &>/dev/null; then
				_lesspipe=${_p}
				break
			fi
		done
		unset _p
		[[ -n "${_lesspipe}" ]] && export LESSOPEN="|${lesspipe} %s"
		unset _lesspipe
	}

	if [[ "${TERM}" = 'xterm-color' || "${TERM}" = 'xterm-256color' ]]; then
		export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
		export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
		export LESS_TERMCAP_me=$'\E[0m'           # end mode
		export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
		export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
		export LESS_TERMCAP_ue=$'\E[0m'           # end underline
		export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
	fi
fi

# -- sudo ---------------------------------------------------------------------

[[ -z "${SUDO_PROMPT}" ]] && {
	export SUDO_PROMPT="[sudo] password for $(id -un): "
}
