{pkgs, ...}:
{
	systemd.services.benno_backup = {
		description = "Restic backup to Storage Box via rclone";
		after = [ "network-online.target" ];
		wants = [ "network-online.target" ];

		serviceConfig = {
			Type = "oneshot";
			WorkingDirectory = "/etc/nixos/systems/x86_64-linux/huygens/cron";
			ExecStart = "/etc/nixos/systems/x86_64-linux/huygens/cron/benno_backup.sh";

			# Optional but recommended if your script needs these tools available
			User = "root";
		};

		path = with pkgs; [
		bash
		rclone
		restic
		fuse3
		coreutils
		util-linux
		gnugrep
		];
	};

	systemd.timers.restic-storagebox-backup = {
		description = "Run restic storage box backup every day at 10:00";

		wantedBy = [ "timers.target" ];

		timerConfig = {
			OnCalendar = "*-*-* 10:00:00";
			Persistent = true;
			Unit = "benno_backup.service";
		};
	};
}
