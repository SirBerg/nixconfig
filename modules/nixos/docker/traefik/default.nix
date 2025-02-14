#Common Nix Packages
{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.docker.containers.traefik;
	hashNewDockerFile = builtins.readFile ./docker-compose.yml;
	hashOldDockerFile = if builtins.pathExists ./docker-compose.yml.back == true then builtins.readFile ./docker-compose.yml.back else "";
in
{
	options.boerg.docker.containers.traefik.enable = mkOption {
		type = bool;
		default = false;
	};

	config = mkIf cfg.enable {
        boerg.virt.docker.enable = true;
        # Check if the hash of the docker-compose.yml file has changed
        # and restart the traefik service if it has
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

            reloadIfChanged = true;
            reloadTriggers = [builtins.hashFile ./docker-compose.yml];
        };

        systemd.services.traefik-watcher = {
            enable = false;
            serviceConfig = {
                WorkingDirectory = "/etc/nixos/modules/nixos/docker/traefik";
                Type = "oneshot";
                ExecStart="/run/current-system/sw/bin/systemctl restart traefik";
            };
            wantedBy = [ "multi-user.target" ];
        };
        environment.etc."nixos/modules/nixos/docker/traefik/docker-compose.yml.back".source = builtins.toFile "docker-compose.yml" (builtins.readFile ./docker-compose.yml);
	};
}
