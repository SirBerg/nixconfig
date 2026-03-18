#Common Nix Packages
{ config, lib, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.services.rdp;
in
{
  options.boerg.services.rdp.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
	  services.xrdp = {
	  	enable = true;
		openFirewall = true;
		port = 3389;
		defaultWindowManager = "plasmashell";
	  };
  };
}
