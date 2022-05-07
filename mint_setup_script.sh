#! /bin/bash

: 'Only run this after configuring the following:

1. Newest Linux Kernel that is able to boot without charging.
2. WI-FI and NVidia drivers installed.'



if [[ $EUID -ne 0 ]]; then
   echo "Mint automatic setup script: permission denied. Run as root." 
   exit 1
fi


total_ops_count=20


echo "1/$total_ops_count: disabling WI-FI power management."
sed -i 's/wifi.powersave = 3/wifi.powersave = 2/' /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf

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

echo "5/$total_ops_count: setting charge threshold to 60%."

echo "[Unit]
Description=Set the battery charge threshold
After=multi-user.target

StartLimitBurst=0
[Service]
Type=oneshot
Restart=on-failure

ExecStart=/bin/bash -c 'echo 60 > /sys/class/power_supply/BAT0/charge_control_end_threshold'
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/battery-charge-threshold.service

systemctl enable battery-charge-threshold.service 
systemctl start battery-charge-threshold.service

echo "6/$total_ops_count: installing Spotify."
apt install spotify-client

echo "7/$total_ops_count: installing Flameshot."
apt install flameshot
flameshot config 
echo "Openned Flameshot config to enable launch on startup and disable prompt."

echo "8/$total_ops_count: setting Discord."



