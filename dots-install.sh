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
    # src <- target
    target=${src#"$LINUX_STUFF/files"}

    SUDO=""
    if [[ "$target" != "$LINUX_STUFF/files/$HOME"* ]]; then
        SUDO="sudo"
    fi

    if samefile "$src" "$target"; then
        echo "$target already linked. Skipping..."
    elif [ -e "$target" ]; then
        read -p "File $target exists. Replace, skip or back up? (y/s/b)" resp

        case $resp in
            [Yy]* ) $SUDO ln -vf "$src" "$target"
                ;;
            [Bb]* ) $SUDO ln -vf "$target" "$src"
                ;;
            * ) echo "Skipping $target..."
                ;;
        esac
    else
        $SUDO mkdir -p $(dirname "$target") && $SUDO ln -v "$src" "$target"
    fi
done
