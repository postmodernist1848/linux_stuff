rp=$(realpath $@)
dest="$HOME/linux_stuff/root$rp"

if  [[ "$rp" == "$HOME"* ]]; then
    dest=$HOME/linux_stuff/home${rp#"$HOME"}
fi

mkdir -p $(dirname "$dest")
cp -v $rp $dest
