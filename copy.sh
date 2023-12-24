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
chmod 600 $HOME/.ssh/{id_rsa,known_hosts}
chmod 644 $HOME/.ssh/{id_rsa.pub,githubpat}

sudo umount -v $partition
sudo rmdir /run/media/postmodernist1488/mountpoint

