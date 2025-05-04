#Common Nix Packages
{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.browser.brave;
in
{
	options.boerg.packages.browser.brave.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        brave
      ];
	};
}
