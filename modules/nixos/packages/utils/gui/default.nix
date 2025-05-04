{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
  cfg = config.boerg.packages.utils.gui;
in
{
  options.boerg.packages.utils.gui.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
	environment.systemPackages = with pkgs;[
        ausweisapp
        obsidian
        anki-bin
        spotify
        bluetuith
    ];

    #Ausweisapp firewall ports
    networking.firewall = {
      allowedUDPPorts = [ 24727 ];
      allowedTCPPorts = [ 24727 ];
    };
  };
}