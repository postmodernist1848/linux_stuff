#! /bin/bash

: '

Only run this after configuring the following:

1. Newest Linux Kernel that is able to boot without charging.
2. WI-FI and NVidia drivers installed.

#### STUFF THAT THIS SCRIPT DOES NOT DO ####
After the the successful execution of this script, the user (me) is advised to:
5. Log into Firefox and sync.
6. Install discord (flatpak) from software manager.

' 


if [[ $EUID -ne 0 ]]; then
   echo "Mint automatic setup script: permission denied. Run as root." 
   exit 1
fi

total_ops_count=18
user=$(logname)

echo "1/$total_ops_count: disabling WI-FI power management."
sed -i 's/wifi.powersave = 3/wifi.powersave = 2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf

echo "2/$total_ops_count: updating all packages."
apt update -qq
apt-get upgrade -y > /dev/null

echo "3/$total_ops_count: installing git."
apt-get install git -y > /dev/null
echo "Configuring user name and email."
git config --global user.name "postmodernist1488"
git config --global user.email elitic.pantheism@gmail.com

echo "4/$total_ops_count: installing Visual Studio Code."
if dpkg -s code &> /dev/null; then
    echo "Visual Studio Code is already installed."
else
    wget -q --show-progress -O code.deb https://go.microsoft.com/fwlink/?LinkID=760868
    apt-get install ./code.deb -y > /dev/null
    rm code.deb
fi

echo "5/$total_ops_count: installing auto-cpufreq."
if [ ! -d auto-cpufreq ] && ! auto-cpufreq --help &> /dev/null; then
    su $user -c "git clone --quiet https://github.com/AdnanHodzic/auto-cpufreq.git"
fi

if ! auto-cpufreq --help &> /dev/null; then
cd auto-cpufreq && ./auto-cpufreq-installer --install > /dev/null 2> auto-cpufreq_error.log
auto-cpufreq --install > /dev/null
cd ..
else echo "Auto-cpufreq is already installed."
fi

charge_threshold=60
echo "6/$total_ops_count: setting charge threshold to $charge_threshold%."

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

echo "7/$total_ops_count: installing Spotify."
apt-get install spotify-client -y > /dev/null

echo "8/$total_ops_count: installing Flameshot."
apt-get install flameshot -y > /dev/null
echo "Openning Flameshot config to enable launch on startup and disable prompt."
su $user -c "flameshot config" 

echo "9/$total_ops_count: adding grub background picture."
cp ameer-basheer-gV6taBJuBTk-unsplash.jpg /boot/grub
update-grub 2> /dev/null
: '
echo "11/$total_ops_count: installing extensions and desklets."

if [ ! -e /home/$user/.local/share/cinnamon/extensions ]; then
su $user -c "mkdir -p /home/$user/.local/share/cinnamon/extensions"
fi
if [ ! -e /home/$user/.local/share/cinnamon/desklets ]; then
su $user -c "mkdir -p /home/$user/.local/share/cinnamon/desklets"
fi

if [ ! -e /home/$user/.local/share/cinnamon/extensions/transparent-panels@germanfr ]; then
    echo "Installing transparent panels."
    wget -q --show-progress -O transparent-panels@germanfr.zip https://cinnamon-spices.linuxmint.com/files/extensions/transparent-panels@germanfr.zip?time=1652001340
    su $user -c "unzip -qq transparent-panels@germanfr.zip -d /home/$user/.local/share/cinnamon/extensions"
fi
 
if [ ! -e /home/$user/.local/share/cinnamon/extensions/gTile@shuairan ]; then
    echo "Installing gTile."
    wget -q --show-progress -O gTile@shuairan.zip https://cinnamon-spices.linuxmint.com/files/extensions/gTile@shuairan.zip?time=1652001340
    su $user -c "unzip -qq gTile@shuairan.zip -d /home/$user/.local/share/cinnamon/extensions"
fi

if [ ! -e /home/$user/.local/share/cinnamon/desklets/simple-system-monitor@ariel ]; then
    echo "Installing simple system monitor desklet."
    wget -q --show-progress -O simple-system-monitor@ariel.zip https://cinnamon-spices.linuxmint.com/files/desklets/simple-system-monitor@ariel.zip?time=1652002289
    su $user -c "unzip -qq simple-system-monitor@ariel.zip -d /home/$user/.local/share/cinnamon/desklets"
fi

#Removing unzipped archives.
if ls *.zip &> /dev/null; then
    rm *.zip
fi
'
echo "10/$total_ops_count: installing vim and copying .vimrc."
apt-get install vim -y > /dev/null

#echo "12/$total_ops_count: importing settings for gnome terminal."
#dconf load /org/gnome/terminal/ < gnome_terminal_settings_backup.txt

echo "11/$total_ops_count: installing pyglet."
su $user -c "pip install pyglet | tail -1" 

echo "12/$total_ops_count: installing Steam."
apt-get install steam -y > /dev/null

echo "13/$total_ops_count: installing GIMP."
apt-get install gimp -y > /dev/null

echo "14/$total_ops_count: installing htop."
apt-get install htop -y > /dev/null

echo "15/$total_ops_count: copying desktop files."
su $user -c "cp -r Desktop/ /home/$user"

echo "16/$total_ops_count: installing i3, urxvt, feh, rofi, compton, fonts-mplus, xsettingsd and lxappearance."
apt-get install i3 rxvt-unicode feh rofi compton fonts-mplus xsettingsd lxappearance -y > /dev/null

echo "17/$total_ops_count: copying config files to home directory."
for f in .bashrc .vimrc .Xresources .xsettingsd do
su $user -c "cp $f ~"
done
su $user -c "cp -r .config ~"
echo "18/$total_ops_count: opening lxappearance."

echo "Configuration finished. Now copy files from external disk."
