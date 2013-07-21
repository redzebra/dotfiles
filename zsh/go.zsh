if type go &>/dev/null; then
  function setup_go_root() {
    local GOPATH=`which go`
    local GODIR=`dirname ${GOPATH}`
    local GOPATH_BREW_RELATIVE=`readlink ${GOPATH}`
    local GOPATH_BREW=`dirname ${GOPATH_BREW_RELATIVE}`
    export GOROOT=`cd ${GODIR}; cd ${GOPATH_BREW}/..; pwd`
  }
  setup_go_root
fi
