#Common Nix Packages
{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.docker;
in
{
	options.boerg.docker.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
        environment.systemPackages = with pkgs;[
          docker-compose
        ];
        virtualisation.docker = {
          enable = true;
          daemon.settings = {
            "log-driver" = "json-file";
            "log-opts" = {
              "tag" = "{{.Name}}";
            };
          };
        };
        virtualisation.oci-containers.backend = "docker";
	};
}
