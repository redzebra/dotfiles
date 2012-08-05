if [[ "$(uname -s)" = Linux && "${SHLVL}" = 1 ]]; then
	[[ -x /usr/bin/clear_console ]] && /usr/bin/clear_console -q
fi

command -v sudo >/dev/null && command sudo -k
