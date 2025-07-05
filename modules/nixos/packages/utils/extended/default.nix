{ config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.packages.utils.extended;
in
{
  options.boerg.packages.utils.extended.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;[
      neofetch
      nmap
      coolercontrol.coolercontrol-gui
      coolercontrol.coolercontrol-ui-data
      rclone
      clinfo
      networkmanagerapplet
      nodejs
      wine64
      winetricks
      wineWowPackages.waylandFull
      coolercontrol.coolercontrol-liqctld
      coolercontrol.coolercontrold
      mangohud
      mplayer
      audacity
      multiviewer-for-f1
      attic-client
      jdk21
      gimp
      icu
      vscode-fhs
      protontricks
      lutris
      obs-studio
      vesktop
#      davinci-resolve
    ];
    programs.coolercontrol.nvidiaSupport = true;
    programs.coolercontrol.enable = true;
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };
  };
}
