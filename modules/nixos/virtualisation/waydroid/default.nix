#Common Nix Packages
{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.virt.waydroid;
in
{
	options.boerg.virt.waydroid.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
    # Enable Waydroid
    virtualisation.waydroid.enable = true;
	};
}
