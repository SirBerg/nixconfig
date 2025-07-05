{ config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.packages.neovim;
in
{
  options.boerg.packages.neovim.enable = mkOption {
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
