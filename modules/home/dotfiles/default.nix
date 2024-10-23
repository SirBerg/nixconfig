
{ pkgs, options, config, lib, ... }:
let
	cfg = config.boerg.dotfiles;
in
{
  options.boerg.doftiles.enable = lib.mkOption{
	default = false;
	type = lib.types.bool;
  };
  config = lib.mkIf cfg.enable {
	  home.file.".config/swaylock/config" = {
		enable = true;
		source = builtins.readFile ./dotfiles/swaylock.conf;
	  };
  };
}
