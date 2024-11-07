{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.utils;
in
{
	options.boerg.packages.utils.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs;[
				git
				discord
        			wget
        			tree
        			unzip
        			killall
        			neofetch
        			nmap
        			btop
        			docker-compose
        			dig
				coolercontrol.coolercontrol-gui
				coolercontrol.coolercontrol-ui-data
				rclone
        			xsel
        			pciutils
        			clinfo
        			cifs-utils
        			tmux
        			lnav
        			kitty
        			rclone
        			networkmanagerapplet
        			nodejs
        			traceroute
				coolercontrol.coolercontrol-liqctld
				coolercontrol.coolercontrold

		];
		programs.coolercontrol.nvidiaSupport = true;
		programs.coolercontrol.enable = true;
		};
}