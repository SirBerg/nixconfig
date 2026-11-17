#!/run/current-system/sw/bin/bash
rclone --config /solaris/user/benno/rclone.conf sync -P warmind:/containers /solaris/user/warmind --exclude "S.gpg-agent*" --exclude "*.lock" --exclude "*.sock" --exclude "faketty"
