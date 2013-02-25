fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)

autoload -Uz colors
colors

autoload -U select-word-style
select-word-style bash

export CLICOLOR=1

export EDITOR=vi
export PAGER=less
export VISUAL=vim

for script in $HOME/.zsh/rc/*.zsh; do
	source $script
done
