#!/bin/sh -e
#
# Install FreeBSD packages with Pkgng.
#

BASE_DIR=${BASE_DIR:-$(cd "$(dirname "$0")/../.." || exit; pwd -P)}

cd "$(dirname "$0")" || exit 1
. "../../share/bootstrap/utils.sh"
. "../../share/bootstrap/utils_freebsd.sh"

_run() {
    printe_h2 "Installing packages..."

    pkgng_bootstrap

    pkgng_install aria2
    pkgng_install aspell
    pkgng_install base64
    pkgng_install ca_root_nss
    pkgng_install compat8x-amd64
    pkgng_install curl
    pkgng_install en-aspell
    pkgng_install fzf
    pkgng_install git
    pkgng_install mercurial
    pkgng_install mosh
    pkgng_install oksh
    pkgng_install openjdk8-jre
    pkgng_install pstree
    pkgng_install py37-ansible
    pkgng_install py37-tmuxp
    pkgng_install socat
    pkgng_install the_silver_searcher
    pkgng_install tmux
    pkgng_install w3m
}

_run_desktop() {
    printe_h2 "Installing desktop packages..."

    pkgng_install emacs
    pkgng_install firefox

    sh "$BASE_DIR/libexec/packages/fontinst.sh" "$@"
}

_run_dev() {
    printe_h2 "Installing dev packages..."

    pkgng_install GraphicsMagick
    pkgng_install autoconf
    pkgng_install duplicity
    pkgng_install elixir
    pkgng_install entr
    pkgng_install erlang
    pkgng_install execline
    pkgng_install expect
    pkgng_install git-crypt
    pkgng_install git-lfs
    pkgng_install go
    pkgng_install graphviz
    pkgng_install hs-ShellCheck
    pkgng_install hs-cabal-install
    pkgng_install hs-pandoc
    pkgng_install ipcalc
    pkgng_install jq
    pkgng_install leiningen
    pkgng_install node10
    pkgng_install npm-node10
    pkgng_install pkgconf
    pkgng_install py37-pip
    pkgng_install python37
    pkgng_install rebar3
    pkgng_install ruby
    pkgng_install socat
    pkgng_install terraform
    pkgng_install tree

    sh "$BASE_DIR/libexec/packages/cloudflared.sh" "$@"
    sh "$BASE_DIR/libexec/packages/cncf.sh" "$@"
    sh "$BASE_DIR/libexec/packages/erlang.sh" "$@"
    sh "$BASE_DIR/libexec/packages/elixir.sh" "$@"
    sh "$BASE_DIR/libexec/packages/golang.sh" "$@"
    sh "$BASE_DIR/libexec/packages/haskell.sh" "$@"
    sh "$BASE_DIR/libexec/packages/node.sh" "$@"
    sh "$BASE_DIR/libexec/packages/python.sh" "$@"
    sh "$BASE_DIR/libexec/packages/rust.sh" "$@"
}

_run_all() {
    run_with_flavors "$@"

    printe_h2 "Installing extra packages..."

    # Only install emacs-nox when other variant of Emacs hasn't been
    # installed (e.g. desktop flavor installs emacs-x11)
    if ! pkgng_installed emacs; then
        pkgng_install emacs-nox
    fi
}

_run_all "$@"
