{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.tailscale;
in
{
	options.boerg.packages.tailscale.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs;
		[
            tailscale
            tail-tray
		];
		services.tailscale.enable = true;
		# To fix dns exit-node issue
		#services.tailscale.interfaceName = "userspace-networking";
		services.tailscale.useRoutingFeatures = "both";
		networking.firewall.trustedInterfaces = [  "tailscale0" ];
		networking.firewall.checkReversePath = "loose";
	};
}