{ options, config, lib, pkgs, ... }:

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
  };
}
