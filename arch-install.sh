# This is an outdated script. Use for reference
echo "Installing dotfiles"
./dots-install

echo "Configuring git"
git config --global user.email "elitic.pantheism@gmail.com"
git config --global user.name "postmodernist1848"

echo "Installing packer for neovim"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "Changing /etc/systemd/logind.conf to enable suspend on lid close"
sudo cp -v logind.conf /etc/systemd/

echo "Adding update-grub script to /usr/sbin/"
sudo cp update-grub /usr/sbin/

echo "changing GRUB to 1920x1080 mode"
sudo sed -i 's/GRUB_GFXMODE=auto/GRUB_GFXMODE=1920x1080,auto/' /etc/default/grub
sudo update-grub

# use alacritty as the terminal in nemo
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty

echo "installing Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Installing yay"
 
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

./copy.sh

