sudo cp -v sudoers /etc/
echo 'you might wanna sudo rm -v /etc/sudoers.d/*'

sudo pacman -Syu

sudo pacman -S flameshot picom nemo discord clang

./dots-backup.sh --install

sudo cat > default-wifi-powersave-on.conf << EOF
[connection]
wifi.powersave = 2
EOF

git config --global user.email "elitic.pantheism@gmail.com"
git config --global user.name "postmodernist1488"

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
           https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
