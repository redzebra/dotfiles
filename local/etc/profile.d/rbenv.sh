if [ -d ~/.rbenv/bin ]; then
	export PATH="~/.rbenv/bin:${PATH}"
	eval "$(rbenv init -)"
fi
