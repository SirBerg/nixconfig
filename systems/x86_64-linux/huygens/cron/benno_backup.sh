#!/run/current-system/sw/bin/bash
source ./benno.env
export RESTIC_PROGRESS_FPS=5
mkdir /benno_usr_dir_mnt
mkdir /mnt/user/benno
rclone mount --config /solaris/user/benno/rclone.conf bennoStorageBox:/ /benno_usr_dir_mnt --allow-other & 
disown
mount --bind /solaris/user/benno /mnt/user/benno
sleep 3

echo "Backing up User Dir"
restic -r /benno_usr_dir_mnt/repos/userDir backup /mnt/user/benno
echo "Backed up User Dir"
fusermount3 -u /benno_usr_dir_mnt
umount /mnt/user/benno
