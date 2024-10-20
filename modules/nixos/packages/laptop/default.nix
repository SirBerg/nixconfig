{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.laptop;
in
{
	options.boerg.packages.laptop.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {

		environment.systemPackages = with pkgs;
		[
			obsidian
			anki-bin
			jetbrains.webstorm
			jetbrains.clion
			jetbrains.rust-rover
			jetbrains.jdk
			jetbrains.datagrip
			spotify
			chromium
		];
	};
}
