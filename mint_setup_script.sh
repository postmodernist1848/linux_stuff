#! /bin/bash

: '

Only run this after configuring the following:

1. Newest Linux Kernel that is able to boot without charging.
2. WI-FI and NVidia drivers installed.

#### STUFF THAT THIS SCRIPT DOES NOT DO ####
After the the successful execution of this script, the user (me) is advised to:
5. Log into Firefox and sync.

' 

if [[ $EUID -ne 0 ]]; then
   echo "Mint automatic setup script: permission denied. Run as root." 
   exit 1
fi

total_ops_count=17
user=$SUDO_USER
echo "Setting up for user $user"
echo "1/$total_ops_count: disabling WI-FI power management."
sed -i 's/wifi.powersave = 3/wifi.powersave = 2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf

echo "2/$total_ops_count: updating all packages."
apt-get update -qq
apt-get upgrade -y > /dev/null

echo "3/$total_ops_count: installing git."
apt-get install git -y > /dev/null
echo "Configuring user name and email."
su $user -c 'git config --global user.name "postmodernist1488"'
su $user -c "git config --global user.email elitic.pantheism@gmail.com"

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
cd auto-cpufreq && ./auto-cpufreq-installer --install > /dev/null 2> ../auto-cpufreq_error.log
auto-cpufreq --install > /dev/null
cd ..
rm -rf auto-cpufreq
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
echo "Opening flameshot settings to disable help prompt."
flameshot config


echo "9/$total_ops_count: adding grub background picture."
cp ameer-basheer-gV6taBJuBTk-unsplash.jpg /boot/grub
update-grub 2> /dev/null

echo "10/$total_ops_count: installing vim and copying .vimrc."
apt-get install vim -y > /dev/null

echo "11/$total_ops_count: installing pyglet."
su $user -c "pip install pyglet | tail -1" 

echo "12/$total_ops_count: installing Steam."
apt-get install steam -y > /dev/null

echo "13/$total_ops_count: installing GIMP."
apt-get install gimp -y > /dev/null

echo "14/$total_ops_count: installing htop."
apt-get install htop -y > /dev/null

echo "15/$total_ops_count: installing i3, urxvt, feh, rofi, compton, fonts-mplus, xsettingsd, lxappearance and xcape."
apt-get install i3 rxvt-unicode feh rofi compton fonts-mplus xsettingsd lxappearance xcape -y > /dev/null

echo "16/$total_ops_count: copying config files to home directory."
for f in .bashrc .vimrc .Xresources .xsettingsd 
do
su $user -c "cp -v $f ~"
done
su $user -c "cp -rv .config ~"
su $user -c "cp -v .urxvt ~"

echo "17/$total_ops_count: installing Iosevka font and icomoon."
if [ $(fc-list | grep -i "Iosevka Term" | wc -l) -eq 0 ]; then
wget -q --show-progress -O iosevka.zip https://github.com/be5invis/Iosevka/releases/download/v15.3.1/super-ttc-sgr-iosevka-term-15.3.1.zip
unzip -qq iosevka.zip -d .fonts
rm iosevka.zip
su $user -c "cp -r .fonts ~"
rm -rf .fonts/iosevka
else
echo "Iosevka is already installed."
su $user -c "cp -r .fonts ~"
fi
fc-cache > /dev/null
su $user -c "xrdb ~/.Xresources"
echo "Configuration finished. Now copy files from external disk."
