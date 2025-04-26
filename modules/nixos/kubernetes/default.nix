#Common Nix Packages
{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.docker.containers.adguard;
in
{
	options.boerg.kubernetes.enable = mkOption {
		type = bool;
		default = false;
	};
    options.boerg.kubernetes.role = mkOption {
        type = enum ["server" "node"];
        default = "node";
    };
    options.boerg.kubernetes.address = mkOption {
        type = str;
        required = true;
    };
	config = mkIf cfg.enable {
        networking.firewall.allowedTCPPorts = {
            mkIf cf.role == "server" [
                6443
            ];
            2379
            2380
            10250
        ];
        networking.firewall.allowedUDPPorts = {
            8472
        };

        services.k3s.enable = true;
        services.k3s.role = cfg.mode;

        services.k3s = {
            enable = true;
            role = cfg.role;
            token = "SundanceClusterSecret"; #Change this later ;)
            serverAddr = "https://10.124.0.2:6443";
        };
	};
}
