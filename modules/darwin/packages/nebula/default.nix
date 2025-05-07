{ options, config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.packages.nebula;
in
{
  options.boerg.packages.nebula.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs;
      [
      ];
  };
}
