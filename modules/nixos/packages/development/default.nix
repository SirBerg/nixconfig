{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.development;
in
{
	options.boerg.packages.development.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {

		environment.systemPackages = with pkgs;
		[
			jetbrains.webstorm
			jetbrains.clion
			jetbrains.rust-rover
			jetbrains.jdk
			jetbrains.datagrip
			jetbrains.goland
			gcc
			rustup
			postman
			libcap
			go
		];

		services.solaar = {
			enable = true;
			window = "hide";
			extraArgs = "--restart-on-wake-up";
		};
		programs.steam = {
		  enable = true;
		  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
		  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
		  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
		};

	};
}
