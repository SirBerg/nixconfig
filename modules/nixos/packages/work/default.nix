{ config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.packages.work;
in
{
  options.boerg.packages.work.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        go
        python3
      ];
  };
}



