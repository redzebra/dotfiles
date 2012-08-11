if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

for p in ~/.local/etc/profile.d/*.sh; do
	. $p
done
