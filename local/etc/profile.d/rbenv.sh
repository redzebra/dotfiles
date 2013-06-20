function rbenv_ps1() {
  local _rbenv_version=$(rbenv version-name 2>/dev/null) || return
  echo " ‹${_rbenv_version}›"
}

if [ -d "${HOME}/.rbenv/bin" ]; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init -)"
fi
