#Common Nix Packages
{ options, config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.hardware.bluetooth;
in
{
  options.boerg.hardware.bluetooth.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        bluetuith
      ];
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Experimental = true;
        };
      };
    };
  };
}
