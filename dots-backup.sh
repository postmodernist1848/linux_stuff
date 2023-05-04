#!/bin/bash

set -e

# This script backs up dot files into linux_stuff directory (git repository) or installs them in the proper location.
backup_dots() { 
    [ "${PWD##*/}" = "linux_stuff" ] || { echo "Current directory is not linux_stuff" && exit 1; }

    rm -r home
        
    # Home directory
    mkdir -pv home
    cp -v ~/{.bashrc,.vimrc} ./home/

    # .config directory
    mkdir home/.config

    #STK produces a lot of logs which are useless for the player
    rm -vf $HOME/.config/supertuxkart/config-0.10/stdout*

    for file in alacritty.yml picom dunst i3 i3status clangd supertuxkart mpv ranger nvim; do
        cp -vr ~/.config/$file home/.config/
    done

}

install_dots() {
    echo "Copying dotfiles to home directory"
    cp -vr ./home/. ~

    read -p "Do you want to create root symlinks? (y/n) " yn
    case $yn in 
        y* ) ;;
        * ) exit 0;;
    esac

    echo "Changing root's dotfiles to symlinks"
    files_to_link=( .bashrc .vimrc .config/nvim/ .config/alacritty.yml .config/compton .config/dunst .config/i3 .config/i3status .vim .config/clangd )
    sudo rm -r /root/.vim
    for f in "${files_to_link[@]}"; do
        sudo ln -svf "$HOME/$f" "/root/$f" 
    done
}

case $# in
    0)
        backup_dots
        ;;
    1)
        case $1 in
            "-b" | "--backup")
                backup_dots
                ;; 
            "-i" | "--install")
                install_dots
                ;;
            *)
                echo "Unknown option $1"; 
                exit 1;
                ;;
        esac
        ;;
    *)
        echo "Too many arguments"
        exit 1
        ;;
esac

