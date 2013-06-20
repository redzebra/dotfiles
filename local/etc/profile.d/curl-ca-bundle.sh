if [ -z "${SSL_CERT_FILE}" ]; then
  if [ -e /usr/local/opt/curl-ca-bundle/share/ca-bundle.crt ]; then
    export SSL_CERT_FILE=/usr/local/opt/curl-ca-bundle/share/ca-bundle.crt
  fi
fi
