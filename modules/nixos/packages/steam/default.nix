{ config, lib, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.packages.steam;
in
{
  options.boerg.packages.steam.enable = mkOption {
    default = false;
    type = bool;
  };
  #Extended utils
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };
}
