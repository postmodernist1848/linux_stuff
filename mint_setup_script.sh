#! /bin/bash

: '

Only run this after configuring the following:

1. Newest Linux Kernel that is able to boot without charging.
2. WI-FI and NVidia drivers installed.

#### STUFF THAT THIS SCRIPT DOES NOT DO ####
After the the successful execution of this script, the user (me) is advised to:
1. Add another layout and change the switch shortcut to alt + shift.
2. Add Flameshot shortcut and disable system PrtSc shortcut.
3. Change desktop background to ~/Pictures/desktop_background and enable slideshow with random ordering.
4. Configure menu (import menu_settings.json file from linux_stuff folder in the applet configurations menu.)
5. Log into Firefox and sync.
6. Install discord (flatpak) from software manager.
7. Add the installed system monitor desklet.
' 


if [[ $EUID -ne 0 ]]; then
   echo "Mint automatic setup script: permission denied. Run as root." 
   exit 1
fi


total_ops_count=10


echo "1/$total_ops_count: disabling WI-FI power management."
sed -i 's/wifi.powersave = 3/wifi.powersave = 2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf

echo "2/$total_ops_count: updating all packages."
apt update
apt upgrade 

echo "2/$total_ops_count: installing git."
apt install git
echo "Configuring user name and email."
git config --global user.name "postmodernist1488"
git config --global user.email elitic.pantheism@gmail.com

echo "3/$total_ops_count: installing Visual Studio Code."
wget -q --show-progress -O code.deb https://go.microsoft.com/fwlink/?LinkID=760868
apt install ./code.deb
rm code.deb

echo "4/$total_ops_count: installing auto-cpufreq."
git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && ./auto-cpufreq-installer
auto-cpufreq --install


charge_threshold=60
echo "5/$total_ops_count: setting charge threshold to $charge_threshold%."

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

echo "6/$total_ops_count: installing Spotify."
apt install spotify-client

echo "7/$total_ops_count: installing Flameshot."
apt install flameshot
echo "Openning Flameshot config to enable launch on startup and disable prompt."
flameshot config 

echo "8/$total_ops_count: copying pictures for desktop background."
cp ./desktop_background ~/Pictures/


echo "9/$total_ops_count: adding grub background picture."
cp ./ameer-basheer-gV6taBJuBTk-unsplash.jpg /boot/grub
update-grub

echo "10/$total_ops_count: installing extensions and desklets."
echo "Installing transparent panels."
wget -q --show-progress -O transparent-panels@germanfr.zip https://cinnamon-spices.linuxmint.com/files/extensions/transparent-panels@germanfr.zip?time=1652001340
unzip -qq transparent-panels@germanfr.zip -d ~/.local/share/cinnamon/extensions 
echo "Installing gTile."
wget -q --show-progress -O gTile@shuairan.zip https://cinnamon-spices.linuxmint.com/files/extensions/gTile@shuairan.zip?time=1652001340
unzip -qq gTile@shuairan.zip -d ~/.local/share/cinnamon/extensions
echo "Installing simple system monitor desklet."
wget -q --show-progress -O simple-system-monitor@ariel.zip https://cinnamon-spices.linuxmint.com/files/desklets/simple-system-monitor@ariel.zip?time=1652002289
unzip -qq simple-system-monitor@ariel.zip -d ~/.local/share/cinnamon/desklets
echo "Removing unzipped archives."
rm *.zip

echo "11/$total_ops_count: installing vim and adding .vimrc."
apt install vim
echo ":set number relativenumber
:highlight LineNr ctermfg=grey
:set tabstop=4" > ~/.vimrc

echo "12/$total_ops_count: importing settings for gnome terminal."
dconf load /org/gnome/terminal/ < gnome_terminal_settings_backup.txt

echo "13/$total_ops_count: installing pyglet."
pip install pyglet | tail -1 

