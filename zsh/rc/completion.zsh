setopt listpacked

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns '_*' Guest \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

[[ -d $HOME/.rbenv/completions/rbenv.zsh ]] && fpath=($HOME/.rbenv/completions/rbenv.zsh $fpath)
[[ -d $HOME/.zsh/completions/src ]] && fpath=($HOME/.zsh/completions/src $fpath)

autoload -Uz compinit
compinit

expand-or-complete-with-dots() {
	echo -n "\e[31m...\e[0m"
	zle expand-or-complete
	zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots
