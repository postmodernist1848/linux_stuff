set -xe

echo "Installing sudoers file"
sudo cp -v sudoers /etc/
sudo chown root /etc/sudoers 
sudo rm -v /etc/sudoers.d/*

echo "Installing archlinux-keyring"
sudo pacman -Sy archlinux-keyring
echo "Updating the database and upgrading all packages"
sudo pacman -Syu
echo "Installing additional software with pacman"
sudo pacman -S flameshot picom nemo discord clang redshift tlp \
gvim neovim python-pip mpv brightnessctl ranger ueberzug

echo "Removing rubbish configs and stuff"
sudo pacman -Rns conky
rm -r .config/i3
rm -r .config/alacritty

echo "Installing dotfiles"
./dots-backup.sh --install

echo "Disabling wi-fi power management"
sudo bash -c 'cat > /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf << EOF
[connection]
wifi.powersave = 2
EOF'

echo "Configuring git"
git config --global user.email "elitic.pantheism@gmail.com"
git config --global user.name "postmodernist1488"

echo "Installing node (for coc-nvim)"

curl -sL install-node.vercel.app/lts | sudo bash

echo "Installing packer for neovim"

yay -S nvim-packer-git

echo "Enabling tlp service"
sudo cp -v tlp.conf /etc/
systemctl enable tlp.service

echo "Changing /etc/systemd/logind.conf to enable suspend on lid close"

sudo cp -v logind.conf /etc/systemd/

echo "Adding update-grub script to /usr/sbin/"
sudo cp update-grub /usr/sbin/

echo "changing GRUB to 1920x1080 mode"
sudo sed -i 's/GRUB_GFXMODE=auto/GRUB_GFXMODE=1920x1080,auto/' /etc/default/grub
sudo Vimix-1080p/install.sh
update-grub

# use alacritty as the terminal in nemo
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty

echo "You should copy the fonts now"
