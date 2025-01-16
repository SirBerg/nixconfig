{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.fonts;
in
{
	options.boerg.packages.fonts.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
		fonts.packages = with pkgs; [
			  noto-fonts
			  noto-fonts-cjk-sans
			  noto-fonts-emoji
			  liberation_ttf
			  #mplus-outline-fonts.githubRelease
			  dina-font
			  proggyfonts
			  jetbrains-mono
			  #nerdfonts
			  notonoto
		];
	};
}



