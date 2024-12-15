#/usr/bin/bash
set -euo pipefail

links_to () {
    [ "$(readlink $1)" -eq $2 ]
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
    if [[ "$target" != "$HOME"* ]]; then
        SUDO="sudo"
        echo "warning: symlinking $target with sudo"
    fi

    if links_to "$target" "$src"; then
        echo "$target already linked. Skipping..."
    elif [ -e "$target" ]; then
        read -p "File $target exists. Replace, skip or back up? (y/s/b)" resp
        case $resp in
            [Yy]* ) $SUDO ln -svf "$src" "$target"
                ;;
            [Bb]* ) cp -T "$target" "$src" && $SUDO ln -svf "$src" "$target"
                ;;
            * ) echo "Skipping $target..."
                ;;
        esac
    else
        $SUDO mkdir -p $(dirname "$target") && $SUDO ln -sv "$src" "$target"
    fi
done
