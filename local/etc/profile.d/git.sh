if which mvim >/dev/null 2>&1; then
	export GIT_EDITOR='mvim -f --nomru -c "au VimLeave * !open -a Terminal"'
fi
