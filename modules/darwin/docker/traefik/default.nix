#Common Nix Packages
{ options, config, lib, pkgs, ... }:

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
  options.boerg.docker.containers.traefik.url = mkOption {
    type = str;
    default = "https://traefik.boerg.co";
    description = "URL where Traefik will be accessible";
  };
  config = mkIf cfg.enable {
    boerg.docker.enable = true;
    systemd.services.traefik = {
      enable = true;
      path = [ pkgs.docker-compose pkgs.docker ];
      serviceConfig = {
        WorkingDirectory = "/etc/nixos/modules/nixos/docker/traefik";
        Type = "simple";
        ExecStart = "/run/current-system/sw/bin/docker-compose up";
        ExecStop = "/run/current-system/sw/bin/docker-compose down";

        # This changes everytime the hash of the docker compose file changes so the service will restart
        Description = builtins.hashFile "sha256" ./docker-compose.yml;
        Restart = "always";
      };
      unitConfig = {
        StartLimitInterval = 10;
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "docker.service" ];
      requires = [ "docker.service" ];

      # Restart the service if the docker-compose file changes
      restartIfChanged = true;
    };
    environment.etc."traefik/url".text = cfg.url;
  };
}
