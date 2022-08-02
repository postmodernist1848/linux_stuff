echo "installing sudoers file"
sudo cp -v sudoers /etc/
sudo chown root /etc/sudoers 
echo 'you might wanna sudo rm -v /etc/sudoers.d/*'

echo "updating the database and upgrading all packages"
sudo pacman -Syu

echo "installing additional software with pacman"
sudo pacman -S flameshot picom nemo discord clang redshift tlp \
gvim neovim python-pip mpv brightnessctl ranger ueberzug

echo "installing dotfiles."
./dots-backup.sh --install

echo "disabling wi-fi power management"
sudo cat > default-wifi-powersave-on.conf << EOF
[connection]
wifi.powersave = 2
EOF

echo "configuring git"
git config --global user.email "elitic.pantheism@gmail.com"
git config --global user.name "postmodernist1488"

echo "installing node (for coc-nvim)"

curl -sL install-node.vercel.app/lts | sudo bash

echo "installing vim plug for vim and neovim"

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

sudo su -c sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
echo "setting battery charge threshold."

sudo bash -c 'cat > /etc/systemd/system/battery-charge-threshold.service << EOF
[Unit]
Description=Set the battery charge threshold
After=multi-user.target
StartLimitBurst=0

[Service]
Type=oneshot
Restart=on-failure
ExecStart=/bin/bash -c "echo 60 > /sys/class/power_supply/BAT0/charge_control_end_threshold"

[Install]
WantedBy=multi-user.target > /etc/systemd/system/battery-charge-threshold.service

EOF'


# Use tlp now
#sudo systemctl enable battery-charge-threshold.service 
#sudo systemctl start battery-charge-threshold.service

echo "enabling tlp service"
sudo cp -v tlp.conf /etc/
systemctl enable tlp.service

echo "changing /etc/systemd/logind.conf to enable suspend on lid close"

sudo cp -v logind.conf /etc/systemd/



