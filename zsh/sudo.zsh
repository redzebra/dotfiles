[[ -z "${SUDO_PROMPT}" ]] && {
  export SUDO_PROMPT="[sudo] password for $(id -un): "
}
