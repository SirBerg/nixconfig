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
      nmap
      rclone
      nodejs
      #mplayer
      audacity
      jdk21
    ];
  };
}
