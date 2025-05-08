{ config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.packages.utils.core;
in
{
  options.boerg.packages.utils.core.enable = mkOption {
    default = false;
    type = bool;
  };

  #Extended utils
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs;[
      git
      btop
      lnav
      tmux
      zsh
      compose2nix
      restic
      rclone
    ];

    #services.solaar = {
    #			enable = true;
    #			window = "hide";
    #			extraArgs = "--restart-on-wake-up";
    #		};
  };
}
