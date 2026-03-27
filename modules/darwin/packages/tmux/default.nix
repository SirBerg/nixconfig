{ config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.packages.tmux;
in
{
  options.boerg.packages.tmux.enable = mkOption {
    type = bool;
    default = false;
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
    };
  };
}
