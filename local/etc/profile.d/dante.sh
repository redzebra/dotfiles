if [ -d /opt/dante ]; then
  PATH="/opt/dante/sbin:/opt/dante/bin:${PATH}"
  MANPATH="/opt/dante/man:${MANPATH}"
fi
