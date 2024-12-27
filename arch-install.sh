# This is an incomplete script. Use for reference
echo "Installing dotfiles"
./dots-install

echo "Configuring git"
git config --global user.email "elitic.pantheism@gmail.com"
git config --global user.name "Vladimir Ivanov"

sudo pacman -Sy neovim --noconfirm --needed

echo "Installing packer for neovim"
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo "changing GRUB to 1920x1080 mode"
sudo sed -i 's/GRUB_GFXMODE=auto/GRUB_GFXMODE=1920x1080,auto/' /etc/default/grub
sudo update-grub

echo "Installing yay"
sudo pacman -S --needed --noconfirm base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay

# use alacritty as the terminal in nemo
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty
