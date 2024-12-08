#/usr/bin/bash
set -euo pipefail

samefile () {
    [ -e $1 ] && [ -e $2 ] && [ "$(stat -c '%i' "$1")" = "$(stat -c '%i' "$2")" ]
}

LINUX_STUFF="$HOME/linux_stuff"

if [ ! -d $LINUX_STUFF ]; then
    echo "$LINUX_STUFF directory does not exist." > /dev/stderr
    echo "Clone from:" > /dev/stderr
    echo "https://github.com/postmodernist1848/linux_stuff.git" > /dev/stderr
    echo "git@github.com:postmodernist1848/linux_stuff.git" > /dev/stderr
    exit 1
fi

for src in $(find $LINUX_STUFF/files -type f); do
    SUDO=""
    if [[ "$src" != "$LINUX_STUFF/$HOME"* ]]; then
        SUDO="sudo"
    fi
    target=${src#"$LINUX_STUFF/files"}
    # src <- target

    if samefile "$src" "$target"; then
        echo "$target already linked. Skipping..."
    elif [ -e "$target" ]; then
        diff "$target" "$src"
        read -p "File $target exists. Replace, skip or back up? (y/s/b)" resp

        case $resp in
            [Yy]* ) $SUDO ln -vf "$src" "$target"
                ;;
            [Bb]* ) ./backup.sh "$target"
                ;;
            * ) echo "Skipping $target..."
                ;;
        esac
    else
        $SUDO ln -v "$src" "$target"
    fi
done
