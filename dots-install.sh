samefile () {
    [ "$(stat -c '%i' "$1")" = "$(stat -c '%i' "$2")" ]
}


create_links () {

for file in $(find $1 -type f | cut -d '/' -f2-); do
    src="$HOME/linux_stuff/$1/$file"

    if [ "$1" = "root" ]; then 
        dest="/$file"
    elif [ "$1" = "home" ]; then
        dest="$HOME/$file"
    else
        echo "Error: can only create links to home/ and root/ directories" > /dev/stderr
        exit 1
    fi

    if samefile "$dest" "$src"; then
        echo "$dest and $src are the same file (links). Skipping..."
    elif [ -e "$dest" ]; then
        read -p "File $dest exists. Replace? (y/n)" yn

        case $yn in
            [Yy]* ) ln -vf "$src" "$dest"
                ;;
            * ) echo "Skipping $dest..."
                ;;
        esac
    else
        ln -v "$src" "$dest"
    fi
done
}

create_links "home"
create_links "root"
