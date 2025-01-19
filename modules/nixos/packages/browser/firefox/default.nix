#Common Nix Packages
{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.browser.firefox;
in
{
	options.boerg.packages.browser.firefox.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        firefox
      ];
	};
}
