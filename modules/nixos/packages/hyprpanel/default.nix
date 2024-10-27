{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.hyprpanel;
in
{
	options.boerg.packages.hyprpanel.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
	    environment.systemPackages = with pkgs; [

	    ];
		fonts.packages = with pkgs; [
			  noto-fonts
			  noto-fonts-cjk
			  noto-fonts-emoji
			  liberation_ttf
			  fira-code
			  fira-code-symbols
			  mplus-outline-fonts.githubRelease
			  dina-font
			  proggyfonts
			  jetbrains-mono
			  nerdfonts
		];
		qt.enable = true;
	};
}



