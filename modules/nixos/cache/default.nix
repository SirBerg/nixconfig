{ config, lib, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.cache;
in
{
  options.boerg.cache.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    nix.settings = {
      substituters = [
        # nix community's cache server
        "http://localhost:3000/default"
      ];
    };
  };
}
