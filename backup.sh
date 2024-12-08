set -euo pipefail

src=$(realpath "$@")
target="$HOME/linux_stuff/files$src"

mkdir -p $(dirname "$target")
ln -v "$src" "$target"
