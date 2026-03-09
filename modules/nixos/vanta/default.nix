{ config, lib, self, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.vanta;
in
{

  options.boerg.vanta.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
	environment.systemPackages = [pkgs.boerg.vanta];
	systemd.tmpfiles.rules = [
	  "d /var/vanta 0755 root root -"
	];
	systemd.services.vanta-agent-pre = {
		name = "vanta-agent-pre.service";
		description = "copy vanta files";
		wantedBy = ["multi-user.target"];
		after = [
			"network.service"
			"syslog.service"
		];
		serviceConfig = {
			TimeoutStartSec = "0";
			User = "root";
			ExecStart = "/var/vanta/metalauncher";
			RemainAfterExit = false;
			WorkingDirectory = "/var/vanta";
			StateDirectory = "vanta-agent";
			KillMode = "control-group";
			KillSignal = "SIGTERM";
			Restart = "on-failure";
			ExecStartPre = [
				"${pkgs.bash}/bin/bash -c 'cp ${pkgs.boerg.vanta}/var/vanta/* /var/vanta'"
			];
		};
	};
  };
}
