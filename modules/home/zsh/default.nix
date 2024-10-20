{ pkgs, options, config, lib, ... }:
let
	cfg = config.boerg.zsh;
in
{
  options.boerg.zsh.enable = lib.mkOption{
	default = false;
	type = lib.types.bool;
  };
  config = lib.mkIf cfg.enable {
	  programs.zsh = {
	    	enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;

		shellAliases = {
			update = "sudo nixos-rebuild switch";
		};

		history = {
			size = 10000;
			path = "${config.xdg.dataHome}/zsh/history";
		};

		oh-my-zsh = {
			enable = true;
			plugins = [ "git" ];
			theme = "robbyrussell";
		};
	  };
  };
}
