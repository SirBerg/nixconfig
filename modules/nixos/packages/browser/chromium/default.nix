#Common Nix Packages
{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.browser.chromium;
in
{
	options.boerg.packages.browser.chromium.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        chromium
      ];
	};
}
