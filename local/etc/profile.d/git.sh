if command -pv mvim >/dev/null; then
	export GIT_EDITOR='command -p mvim -f -n --nomru -c "set stal=0"'
fi
