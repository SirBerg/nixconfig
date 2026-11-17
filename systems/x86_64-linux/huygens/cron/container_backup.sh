#!/run/current-system/sw/bin/bash
source ./benno.env
export RESTIC_PROGRESS_FPS=5
mkdir /container_dir_mnt
mkdir /mnt/user/containers
rclone mount --config /solaris/user/benno/rclone.conf bennoStorageBox:/ /container_dir_mnt --allow-other & 
disown
mount --bind /solaris/containers /mnt/user/containers
sleep 3

echo "Backing up User Dir"
restic -r /container_dir_mnt/repos/containerDir backup --exclude /mnt/user/containers/archivist/downloads /mnt/user/containers
restic -r /container_dir_mnt/repos/containerDir backup /appdata/appdata
restic -r /container_dir_mnt/repos/containerDir backup /solaris/compose
echo "Backed up User Dir"
umount /mnt/user/containers
fusermount3 -u /container_dir_mnt
