{ options, config, lib, pkgs, ...}:

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
      wget
      tree
      unzip
      killall
      btop
      dig
      traceroute
      lnav
      pciutils
      cifs-utils
      xsel
      tmux
      zsh
    ];
    services.solaar = {
			enable = true;
			window = "hide";
			extraArgs = "--restart-on-wake-up";
		};
  };
}