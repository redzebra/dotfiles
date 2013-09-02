function rbenv_ps1() {
  local _rbenv_version=$(rbenv version-name 2>/dev/null) || return
  echo " ‹${_rbenv_version}›"
}

[ -d "${HOME}/.rbenv/bin" ] && export PATH="${HOME}/.rbenv/bin:${PATH}"
if which rbenv >/dev/null; then eval "$(rbenv init -)"; fi
