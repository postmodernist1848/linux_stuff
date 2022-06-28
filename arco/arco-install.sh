echo "installing sudoers file"
sudo cp -v sudoers /etc/
echo 'you might wanna sudo rm -v /etc/sudoers.d/*'

echo "updating and upgrading all packages"
sudo pacman -Syu

echo "installing software with pacman"
sudo pacman -S flameshot picom nemo discord clang redshift

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

echo "installing node"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "setting battery charge threshold."
echo "[Unit]
Description=Set the battery charge threshold
After=multi-user.target

StartLimitBurst=0
[Service]
Type=oneshot
Restart=on-failure

ExecStart=/bin/bash -c 'echo $charge_threshold > /sys/class/power_supply/BAT0/charge_control_end_threshold'
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/battery-charge-threshold.service

systemctl enable battery-charge-threshold.service 
systemctl start battery-charge-threshold.service

