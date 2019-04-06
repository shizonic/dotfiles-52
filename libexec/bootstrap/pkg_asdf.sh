#!/bin/sh -e
#
# Install language runtime and its packages with asdf version manager.
#

base_dir=$(cd "$(dirname "$0")/" || exit; pwd -P)
asdf_dir="$HOME/.asdf"

cd "$base_dir" || exit 1
. ../../share/bootstrap/funcs.sh
. ../../share/bootstrap/compat.sh


## Utils
##

_asdf_env() {
    env PATH="$asdf_dir/bin:$asdf_dir/shims:$PATH" "$@"
}

_do_plugin() {
    plugin=$1; shift
    repo=$1; shift

    git_clone_update "$repo" "$asdf_dir/plugins/$plugin"
}

_do_install() {
    plugin=$1; shift
    version=$1; shift

    if [ ! -d "$asdf_dir/installs/$plugin/$version" ]; then
        install="_install"

        if [ "$(command -v "_install_${plugin}")x" != "x" ]; then
            printe_msg "Running custom installation script for $plugin..."
            install="_install_${plugin}"
        fi

        "$install" "$plugin" "$version"
    fi

    if [ "$(has_args "global" "$*")" = "1" ]; then
         _asdf_env asdf global "$plugin" "$version"
    fi

     _asdf_env asdf reshim "$plugin"
}

_do_pkginst() {
    plugin=$1; shift
    instcmd=$*; shift

    pkglist="../../var/bootstrap/pkglist.${plugin}.txt"

    # shellcheck disable=SC2086
    if [ -f "$pkglist" ]; then
        printe_h2 "Installing ${plugin} packages..."
        _asdf_env xargs $instcmd < "$pkglist"
    fi
}


## Installers
##

_install() {
    plugin=$1; shift
    version=$1; shift

    _asdf_env asdf install "$plugin" "$version"
}

_install_ruby() {
    plugin=$1; shift
    version=$1; shift

    case "$(uname)" in
        FreeBSD )
            if ! hash gcc 2>/dev/null; then
                printe_err "Building Ruby on FreeBSD requires GCC"
                exit 1
            fi

            # For GCC, see https://github.com/ffi/ffi/issues/622
            # For DTrace, see https://github.com/rbenv/ruby-build/issues/1272
            env \
                CC="gcc" \
                CXX="g++" \
                RUBY_CONFIGURE_OPTS="--disable-dtrace" \
                _asdf_env asdf install "$plugin" "$version"
            ;;
        * )
            _asdf_env asdf install "$plugin" "$version"
            ;;
    esac
}


## Installs
##

printe_h2 "Installing asdf..."

git_clone_update https://github.com/asdf-vm/asdf.git "$asdf_dir"

if [ -f "../../var/bootstrap/asdf.txt" ]; then
    while read -r spec; do
        case "$spec" in
            "#"* | "" ) continue;;
            *) spec="${spec%%#*}";;
        esac

        eval set -- "$spec"

        case "$1" in
            plugin )  shift; _do_plugin  "$@";;
            install ) shift; _do_install "$@";;
            pkginst ) shift; _do_pkginst "$@";;
            * ) printe_err "Unknown directive: $1";;
        esac
    done < "../../var/bootstrap/asdf.txt"
fi
