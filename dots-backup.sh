#!/bin/bash

# This script backs up dot files into linux_stuff directory (git repository) or installs them in the proper location.
backup_dots() { 

[ "${PWD##*/}" = "linux_stuff" ] || { echo "Current directory is not linux_stuff" && exit 1; }

# Home directory
cp -v ~/{.bashrc,.vimrc} ./home/
# .config directory                                         #lol super tux kart
cp -vr ~/.config/{alacritty.yml,compton.conf,dunst,i3,i3status,supertuxkart,.Xmodmap} ./home/.config/
}

install_dots() {
echo "Copying dotfiles to home directory"
cp -vr ./home/. ~

echo "Changing root's dotfiles to symlinks"
files_to_link=( .bashrc .vimrc .config/alacritty .config/compton .config/dunst .config/i3 .config/i3status )
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

