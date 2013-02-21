HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

unsetopt HIST_BEEP
setopt   HIST_EXPIRE_DUPS_FIRST
setopt   HIST_FIND_NO_DUPS
setopt   HIST_IGNORE_ALL_DUPS
setopt   HIST_IGNORE_DUPS
setopt   HIST_IGNORE_SPACE
setopt   HIST_REDUCE_BLANKS
setopt   HIST_SAVE_NO_DUPS
setopt   SHARE_HISTORY

bindkey "^[[A" up-line-or-search
bindkey "^[[B" down-line-or-search
