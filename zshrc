fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

autoload -Uz colors
colors

export EDITOR=vi
export PAGER=less
export VISUAL=vim

for script in $HOME/.zsh/rc/*.zsh; do
	source $script
done
