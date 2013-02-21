case "$(uname)" in
	Darwin)
		export JAVA_HOME="$(/usr/libexec/java_home -t CommandLine -F)"
		;;
esac
