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

	systemd.timers.benno_backup_timer = {
		description = "Run restic storage box backup every day at 10:00";

		wantedBy = [ "timers.target" ];

		timerConfig = {
			OnCalendar = "*-*-* 10:00:00";
			Persistent = true;
			Unit = "benno_backup.service";
		};
	};

	systemd.services.container_backup = {
		description = "Restic backup to Storage Box via rclone";
		after = [ "network-online.target" ];
		wants = [ "network-online.target" ];

		serviceConfig = {
			Type = "oneshot";
			WorkingDirectory = "/etc/nixos/systems/x86_64-linux/huygens/cron";
			ExecStart = "/etc/nixos/systems/x86_64-linux/huygens/cron/container_backup.sh";

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

	systemd.timers.container_backup_timer = {
		description = "Run restic storage box backup every day at 10:00";

		wantedBy = [ "timers.target" ];

		timerConfig = {
			OnCalendar = "*-*-* 13:00:00";
			Persistent = true;
			Unit = "container_backup.service";
		};
	};

	systemd.services.edgar_backup = {
		description = "Restic backup to Storage Box via rclone";
		after = [ "network-online.target" ];
		wants = [ "network-online.target" ];

		serviceConfig = {
			Type = "oneshot";
			WorkingDirectory = "/etc/nixos/systems/x86_64-linux/huygens/cron";
			ExecStart = "/etc/nixos/systems/x86_64-linux/huygens/cron/edgar_backup.sh";

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

	systemd.timers.edgar_backup_timer = {
		description = "Run restic storage box backup every day at 17:00";

		wantedBy = [ "timers.target" ];

		timerConfig = {
			OnCalendar = "*-*-* 17:00:00";
			Persistent = true;
			Unit = "edgar_backup.service";
		};
	};

	systemd.services.warmind_backup = {
		description = "Restic backup to Storage Box via rclone";
		after = [ "network-online.target" ];
		wants = [ "network-online.target" ];

		serviceConfig = {
			Type = "oneshot";
			WorkingDirectory = "/etc/nixos/systems/x86_64-linux/huygens/cron";
			ExecStart = "/etc/nixos/systems/x86_64-linux/huygens/cron/warmind_backup.sh";

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

	systemd.timers.warmind_backup_timer = {
		description = "Run restic storage box backup every day at 17:00";

		wantedBy = [ "timers.target" ];

		timerConfig = {
			OnCalendar = "*-*-* 20:00:00";
			Persistent = true;
			Unit = "warmind_backup.service";
		};
	};

	systemd.services.warmind_sync = {
		description = "Restic backup to Storage Box via rclone";
		after = [ "network-online.target" ];
		wants = [ "network-online.target" ];

		serviceConfig = {
			Type = "oneshot";
			WorkingDirectory = "/etc/nixos/systems/x86_64-linux/huygens/cron";
			ExecStart = "/etc/nixos/systems/x86_64-linux/huygens/cron/warmind_sync.sh";

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

	systemd.timers.warmind_sync_timer = {
		description = "Sync Warmind contents every few hours";

		wantedBy = [ "timers.target" ];

		timerConfig = {
			OnCalendar = [
				"*-*-* 9:00:00"
				"*-*-* 12:00:00"
				"*-*-* 15:00:00"
				"*-*-* 18:00:00"
				"*-*-* 21:00:00"
			];
			Persistent = true;
			Unit = "warmind_sync.service";
		};
	};
}
