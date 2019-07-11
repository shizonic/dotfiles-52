#!/bin/sh -e
#
# Install execline.
#

BASE_DIR=${BASE_DIR:-$(cd "$(dirname "$0")/../.." || exit; pwd -P)}

# shellcheck source=../../share/bootstrap/funcs.sh
. "$BASE_DIR/share/bootstrap/funcs.sh"

if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR=$(mktemp -d)
    trap 'rm -rf $BUILD_DIR' 0 1 2 3 6 14 15
fi


## Utils
##

_fontdir_absent() {
    dest=$1; shift

    if [ -f "$dest/.installed" ]; then
        printe_info "$dest already exists"
        return 1
    fi

    return 0
}

_install_font() {
    srcdir=$1; shift
    dest=$1; shift

    rm -rf "$dest" || exit 1
    mkdir -p "$dest" || exit 1

    find "$srcdir" \
         \( -iname "*.ttf" -or -iname "*.ttc" \) \
         -exec mv \{\} "$dest" \;

    touch "$dest/.installed"
}


## Installers
##

_install_font_gh() {
    name=$1; shift
    repo=$1; shift
    shasum=$1; shift
    ver=$1; shift

    fontdir=$HOME/.data/fonts/$name
    if is_force || _fontdir_absent "$fontdir"; then
        cd "$BUILD_DIR" || exit 1

        fetch_gh_archive \
            "$name.tar.gz" \
            "$repo" \
            "$ver"

        verify_shasum "$name.tar.gz" "$shasum"
        tar -C "$BUILD_DIR" -xzf "$name.tar.gz"
        _install_font \
            "$BUILD_DIR/$name-$(echo "$ver" | tr "/" "-")" \
            "$fontdir"
    fi
}

_install_font_url() {
    name=$1; shift
    url=$1; shift
    shasum=$1; shift

    fontdir=$HOME/.data/fonts/$name
    basename=$(basename "$url")

    if is_force || _fontdir_absent "$fontdir"; then
        cd "$BUILD_DIR" || exit 1

        fetch_url "$basename" "$url"
        verify_shasum "$basename" "$shasum"

        case "$basename" in
            *.tar.gz )
                tar -C "$BUILD_DIR" -xzf "$basename"
                ;;

            *.zip )
                mkdir -p "$BUILD_DIR/$name"
                unzip -d "$BUILD_DIR/$name" "$basename"
                ;;

            *.ttf | *.ttc )
                mkdir -p "$BUILD_DIR/$name"
                mv "$basename" "$BUILD_DIR/$name/"
        esac

        _install_font \
            "$BUILD_DIR/$name" \
            "$fontdir"
    fi
}


## Run
##

_run() {
    printe_h2 "Installing fonts..."

    ## Adobe Source
    ##

    _install_font_gh \
        source-code-pro \
        adobe/source-code-pro \
        a4e4dd59b8e0a436b934f0f612c2e91b5932910c6d1c3b7d1a5a9f389c86302b \
        2.030R-ro/1.050R-it

    _install_font_gh \
        source-sans-pro \
        adobe/source-sans-pro \
        01e78d7ff451545ff1eec6cf14b28f62135e430a7ba80d74a90efd5334fef7eb \
        2.045R-ro/1.095R-it

    _install_font_gh \
        source-serif-pro \
        adobe/source-serif-pro \
        bbb504463342f01666db34790574477b2bbd61a338897466461c66c4cd4464fd \
        3.000R

    ## Adobe Source Han
    ## Full archive for Source Han family are around 1.5GB, so instead we're
    ## downloading the font directly.
    ##

    adobe_gh=https://github.com/adobe-fonts

    _install_font_url \
        source-han-sans \
        $adobe_gh/source-han-sans/releases/download/2.001R/SourceHanSans.ttc \
        9e94fe493685a7c99ce61e4488169007e3b97badb9f1ef43d3c13da501463780

    _install_font_url \
        source-han-serif \
        $adobe_gh/source-han-serif/releases/download/1.001R/SourceHanSerif.ttc \
        85cc634fa228286ca307803bbb4ca61f61fa821b3ed573f4f07c6f0c064426b5

    ## Ubuntu Fonts
    ##

    _install_font_url \
        ubuntu \
        https://assets.ubuntu.com/v1/fad7939b-ubuntu-font-family-0.83.zip \
        456d7d42797febd0d7d4cf1b782a2e03680bb4a5ee43cc9d06bda172bac05b42

    ## Droid Sans
    ## Using local mirror, since Droid Sans has been removed from Google Fonts
    ## in favor for Noto, but Noto Thai wasn't really designed for reading
    ##

    _install_font_url \
        droid-sans-thai \
        https://files.grid.in.th/pub/droid-sans-thai.tar.gz \
        c0f2ab8b3471c3b5ecca4c94400ad489a7e09b811739bdea537c7f4ef9be6a80

    _install_font_url \
        droid-serif-thai \
        https://files.grid.in.th/pub/droid-serif-thai.tar.gz \
        8d27167379ea9718530d35c5872e65f5a09adc99fe505c4d506e9bbaaefe84d7
}

_run