{ config, lib, pkgs, ... }:

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
      obsidian
      anki-bin
      spotify
    ];
  };
}
