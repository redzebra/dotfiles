if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

for p in /usr/local/etc/profile.d/*.sh ~/.local/etc/profile.d/*.sh; do
	. $p
done
