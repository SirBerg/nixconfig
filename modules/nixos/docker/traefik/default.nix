#Common Nix Packages
{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.docker.containers.traefik;
in
{
	options.boerg.docker.containers.traefik.enable = mkOption {
		type = bool;
		default = false;
	};

	config = mkIf cfg.enable {
        boerg.virt.docker.enable = true;
        environment.etc."docker/traefik/docker-compose.yml".source = builtins.toFile "docker-compose.yml" (builtins.readFile ./docker-compose.yml);
        systemd.services.traefik = {
            enable = true;
            path = [ pkgs.docker-compose pkgs.docker ];
            serviceConfig = {
                WorkingDirectory = "/etc/nixos/modules/nixos/docker/traefik";
                Type = "simple";
                ExecStart = "/run/current-system/sw/bin/docker-compose up";
                ExecStop = "/run/current-system/sw/bin/docker-compose down";
                Restart = "always";
            };

            wantedBy = [ "multi-user.target" ];
            after = ["docker.service"];
            requires = ["docker.service"];
        };

        systemd.services.traefik-watcher = {
            enable = true;
            serviceConfig = {
                WorkingDirectory = "/etc/nixos/modules/nixos/docker/traefik";
                Type = "oneshot";
                ExecStart="/run/current-system/sw/bin/systemctl restart traefik";
            };
            wantedBy = [ "multi-user.target" ];
        };

#        systemd.paths.traefik-watcher = {
#            enable = true;
#            pathConfig = {
#                PathModified = "/etc/nixos/modules/nixos/docker/traefik/docker-compose.yml";
#            };
#            wantedBy = [ "multi-user.target" ];
#        };
	};
}
