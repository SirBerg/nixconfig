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
			hoppscotch
			air
			ninja
			cmake
			gnumake42
			bun
		];

		services.solaar = {
			enable = true;
			window = "hide";
			extraArgs = "--restart-on-wake-up";
		};
	};
}
