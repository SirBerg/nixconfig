#Common Nix Packages
{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.docker.containers.grafana;
in
{
	options.boerg.docker.containers.grafana.enable = mkOption {
        type = bool;
        default = false;
	};
	options.boerg.docker.containers.grafana.url = mkOption {
	    type = str;
	    default = "https://warmind.naibu.boerg.co";
	    description = "The Traefik Label URL of the Grafana instance";
	};
	config = mkIf cfg.enable {
        boerg.docker.enable = true;
        environment.etc."nixos/modules/nixos/docker/grafana/docker-compose.override.yml".text = ''
            services:
                grafana:
                    labels:
                      traefik.enable: true
                      traefik.http.routers.traefik.entryPoints: https
                      traefik.http.services.traefik.loadbalancer.server.port: 3000
                      traefik.http.routers.traefik.rule: Host(`${cfg.url}`)
        '';
        systemd.services.grafana = {
            enable = true;
            path = [ pkgs.docker-compose pkgs.docker ];
            serviceConfig = {
                WorkingDirectory = "/etc/nixos/modules/nixos/docker/grafana";
                Type = "simple";
                ExecStart = "/run/current-system/sw/bin/docker-compose -f docker-compose.yml  -f docker-compose.override.yml up";
                ExecStop = "/run/current-system/sw/bin/docker-compose -f docker-compose.yml -f docker-compose.override.yml down";

                # This changes everytime the hash of the docker compose file changes so the service will restart
                Description = builtins.hashFile "sha256" ./docker-compose.yml;
                Restart = "always";
            };
            unitConfig = {
                StartLimitInterval = 10;
            };
            wantedBy = [ "multi-user.target" ];
            after = ["docker.service"];
            requires = ["docker.service"];

            # Restart the service if the docker-compose file changes
            restartIfChanged = true;
        };
	};
}
