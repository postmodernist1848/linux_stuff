samefile () {
    [ -e $1 ] && [ -e $2 ] && [ "$(stat -c '%i' "$1")" = "$(stat -c '%i' "$2")" ]
}


create_links () {

for file in $(find $1 -type f | cut -d '/' -f2-); do
    src="$HOME/linux_stuff/$1/$file"

    if [ "$1" = "root" ]; then 
        dest="/$file"
        SUDO="sudo"
    elif [ "$1" = "home" ]; then
        dest="$HOME/$file"
        SUDO=""
    else
        echo "Error: can only create links to home/ and root/ directories" > /dev/stderr
        exit 1
    fi

    if samefile "$dest" "$src"; then
        echo "$file already linked. Skipping..."
    elif [ -e "$dest" ]; then
        read -p "File $dest exists. Replace, skip or back up? (y/s/b)" yn

        case $yn in
            [Yy]* ) $SUDO ln -vf "$src" "$dest"
                ;;
            [Bb]* ) $SUDO cp $dest $src && $SUDO ln -vf "$src" "$dest"
                ;;
            * ) echo "Skipping $dest..."
                ;;
        esac
    else
        $SUDO ln -v "$src" "$dest"
    fi
done
}

create_links "home"
create_links "root"
