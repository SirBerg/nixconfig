#!/run/current-system/sw/bin/bash
source ./benno.env
export RESTIC_PROGRESS_FPS=5
mkdir /warmind_dir_mnt
rclone mount --config /solaris/user/benno/rclone.conf bennoStorageBox:/ /warmind_dir_mnt --allow-other & 
disown
sleep 3

echo "Backing up User Dir"
restic -r /warmind_dir_mnt/repos/warmindData backup /solaris/user/warmind
echo "Backed up User Dir"
fusermount3 -u /warmind_dir_mnt
