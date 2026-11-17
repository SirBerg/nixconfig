#!/run/current-system/sw/bin/bash
source ./edgar.env
export RESTIC_PROGRESS_FPS=5
mkdir /edgar_usr_dir
mkdir /data
rclone mount --config /solaris/user/benno/rclone.conf bennoStorageBox:/ /edgar_usr_dir --allow-other & 
disown
mount --bind /solaris/user/edgar /data
sleep 3

# Invoke Transfer of dropbox files to local disk
echo "Starting Copy from HiDrive to Localdisk"
rclone sync -P --config "/solaris/user/benno/rclone.conf" --auto-confirm edgarHiDrive:/users/trellisdublin /solaris/user/edgar/data
echo "Done with copying from HiDrive to Localdisk"

echo "Starting Restic Backup"
restic -r /edgar_usr_dir/repos/edgarData backup /data/data --host docker
echo "Done with Restic Backup"

echo "Starting Media Backup"
restic -r /edgar_usr_dir/repos/edgarMedia backup /data/Fotos,\ Musik,\ Medien --host docker
echo "Done with Media backup"
fusermount3 -u /edgar_usr_dir
umount /data
