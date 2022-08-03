#!/bin/bash

# This script backs up dot files into linux_stuff directory (git repository) or installs them in the proper location.
backup_dots() { 

[ "${PWD##*/}" = "linux_stuff" ] || { echo "Current directory is not arco" && exit 1; }
mkdir -pv home/.config/nvim
    
# Home directory
cp -v ~/{.bashrc,.vimrc} ./home/
# .config directory                                         #lol super tux kart
cp -vrT ~/.config/{alacritty.yml,picom,dunst,i3,i3status,clangd,supertuxkart,mpv,ranger} home/.config/

cp -v ~/.config/nvim/init.vim home/.config/nvim/

#STK produces a lot of logs which are useless for the player
rm -v home/.config/supertuxkart/config-0.10/stdout*
}

install_dots() {
echo "Copying dotfiles to home directory"
cp -vr ./home/. ~

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

