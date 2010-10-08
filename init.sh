#!/usr/bin/env zsh
DOTFILES_DIR=`cd ${0%/*} && pwd -P`

# Helper function
function _link_to_home {
    local source_path=$DOTFILES_DIR/$1
    local dest_path=$HOME/$2
    if [[ -e $dest_path ]]; then
        echo "* Skipping $2 as it is already exist."
    else
        echo "* Linking $2 to the home directory"
        mkdir -p `dirname $dest_path` 2>/dev/null
        ln -s $source_path $dest_path
    fi
}

# Installation
_link_to_home zsh/zshrc .zshrc
_link_to_home elisp/emacs .emacs
_link_to_home vim/vimrc .vimrc
_link_to_home vim/vimperatorrc .vimperatorrc
_link_to_home etc/gitconfig .gitconfig
_link_to_home etc/screenrc .screenrc
_link_to_home etc/ssh_config .ssh/config

if [[ $1 == "--with-x" ]]; then
    _link_to_home etc/ratpoisonrc .ratpoisonrc
    _link_to_home etc/Xdefaults .Xdefaults
    _link_to_home etc/awesome.lua ~/.config/awesome/rc.lua
fi