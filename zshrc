fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

autoload -Uz colors
colors

for script in $HOME/.zsh/rc/*.zsh; do
	source $script
done
