#!/bin/sh
#
# Based on abiosoft's fixflatpaktheme.sh
# https://github.com/abiosoft/dotfiles/blob/master/flatpak/fixflatpaktheme.sh
#

CONFS="
gtk-3.0/settings.ini
fontconfig/fonts.conf
fontconfig/conf.d
" # END-QUOTE

OVERRIDES="
~/.config/gtk-3.0
~/.config/fontconfig
~/.local/share/fonts
~/.dotfiles/etc/fontconfig
" # END-QUOTE

for fp in $OVERRIDES; do
    printf >&2 "==> Enabling access to %s\\n" "$fp"
    flatpak override --user --filesystem="$fp"
done

if [ ! -d "$HOME"/.var/app ]; then
    exit 0
fi

for appdir in "$HOME"/.var/app/*; do
    if [ ! -d "$appdir" ]; then
        continue
    fi

    printf >&2 "==> Fixing %s...\\n" "$(basename "$appdir")"

    for file in $CONFS; do
        if [ -L "$appdir/config/$file" ]; then
            continue
        fi

        if [ -f "$HOME/.config/$file" ] || [ -d "$HOME/.config/$file" ]; then
            mkdir -p "$appdir/config/$(dirname "$file")"
            ln -fs "$HOME/.config/$file" "$appdir/config/$file"
        fi
    done
done
