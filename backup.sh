set -euo pipefail

target=$(realpath "$@")
src="$HOME/linux_stuff/files$target"

mkdir -p $(dirname "$src")
cp -T "$target" "$src" && ln -svf "$src" "$target"
