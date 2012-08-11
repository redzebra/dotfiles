if [[ -x /usr/libexec/java_home ]]; then
	_jave_home=$(/usr/libexec/java_home --failfast) && {
		export JAVA_HOME=`/usr/libexec/java_home`
	}
	unset _java_home
fi
