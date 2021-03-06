#!/bin/sh -e
#
# Configure current user on FreeBSD.
#

BASE_DIR=${BASE_DIR:-$(cd "$(dirname "$0")/../.." || exit; pwd -P)}

cd "$(dirname "$0")" || exit 1
. "lib/utils.sh"
. "lib/utils_freebsd.sh"

_run() {
    _setup_user_links
    _setup_user_shell
}

_run_desktop() {
    _setup_desktop_links
}

_run_dev() {
    _setup_dev_links
}

_setup_user_links() {
    printe_h2 "Installing links..."

    make_link "$BASE_DIR/etc/aria2/aria2.conf" "$HOME/.aria2/aria2.conf"
    make_link \
        "$BASE_DIR/etc/emacs/straight/versions/default.el" \
        "$HOME/.emacs.d/straight/versions/default.el"

    make_link "$BASE_DIR/etc/emacs/init.el" "$HOME/.emacs.d/init.el"
    make_link "$BASE_DIR/etc/git/gitconfig" "$HOME/.gitconfig"
    make_link "$BASE_DIR/etc/hg/hgrc" "$HOME/.hgrc"
    make_link "$BASE_DIR/etc/ksh/kshrc" "$HOME/.kshrc"
    make_link "$BASE_DIR/etc/sh/profile" "$HOME/.profile"
    make_link "$BASE_DIR/etc/ssh/config" "$HOME/.ssh/config"
    make_link "$BASE_DIR/etc/tmux/tmux.conf" "$HOME/.tmux.conf"
}

_setup_user_shell() {
    printe_h2 "Changing user shell..."

    change_shell oksh
}

_setup_desktop_links() {
    printe_h2 "Installing desktop links..."

    make_link \
        "$BASE_DIR/etc/fontconfig/conf.d" \
        "$HOME/.config/fontconfig/conf.d"
}

_setup_dev_links() {
    printe_h2 "Installing dev links..."

    make_link "$BASE_DIR/etc/proselint/proselintrc" "$HOME/.proselintrc"
}
