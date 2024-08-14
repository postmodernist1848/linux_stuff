set -e
mountpoint_name=$(echo $1 | sed -E 's|/dev/([a-z0-9]+)|\1|')
mount_path="/mnt/$mountpoint_name" 
sudo mkdir -pv "$mount_path"
sudo mount $1 "$mount_path" && echo "Successfully mounted on $mount_path"

