set -e

echo "Installing sudoers file"
sudo cp -v sudoers /etc/
sudo chown root /etc/sudoers 
sudo rm -vf /etc/sudoers.d/*

echo "Updating the database and upgrading all packages"
sudo pacman -Syu archlinux-keyring --noconfirm
echo "Installing additional software with pacman"
sudo pacman -Sy flameshot picom nemo discord clang redshift tlp \
gvim neovim python-pip mpv brightnessctl ranger ueberzug \
ncdu nasm scrcpy sxiv feh --needed

echo "Removing rubbish configs and stuff"
for package in conky kvantum polybar variety arcolinux-welcome-app; do
    sudo pacman -Rns $(pacman -Qeq | grep $package) --noconfirm || true
    rm -rf $HOME/.config/$package
done

for package in i3 alacritty; do 
    rm -rf $HOME/.config/$package
done

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

#echo "Installing node (for coc-nvim)"
#curl -sL install-node.vercel.app/lts | sudo bash || true

echo "Installing packer for neovim"

#yay -S --needed nvim-packer-git
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "Enabling tlp service"
sudo cp -v tlp.conf /etc/
systemctl enable tlp.service

echo "Changing /etc/systemd/logind.conf to enable suspend on lid close"

sudo cp -v logind.conf /etc/systemd/

echo "Adding update-grub script to /usr/sbin/"
sudo cp update-grub /usr/sbin/

echo "changing GRUB to 1920x1080 mode"
sudo sed -i 's/GRUB_GFXMODE=auto/GRUB_GFXMODE=1920x1080,auto/' /etc/default/grub
#pushd Vimix-1080p
#sudo ./install.sh
#popd
sudo update-grub

# use alacritty as the terminal in nemo
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty

echo "installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

lsblk
read -p "Enter usb partition (/dev/sdXn): " partition
sudo mkdir -p /run/media/postmodernist1488/mountpoint
sudo mount -v $partition /run/media/postmodernist1488/mountpoint
echo "Copying fonts from $partition..."
cp /run/media/postmodernist1488/mountpoint/fonts/ -r $HOME/.local/share/
fc-cache
echo "Copying wallpapers from $partition..."
cp /run/media/postmodernist1488/mountpoint/wallpapers/ -r $HOME/Pictures/
echo "Copying .ssh from $partition..."
cp /run/media/postmodernist1488/mountpoint/.ssh/ -r $HOME/

sudo umount -v $partition
sudo rmdir /run/media/postmodernist1488/mountpoint
