{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages;
in
{
	options.boerg.packages.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs;
		[
			neovim
			git
			wget
			tree
			unzip
			killall
			neofetch
			btop
			dig
			rclone
			xsel
			pciutils
			clinfo
			cifs-utils
			tmux
			lnav
			kitty
		  	noto-fonts
			noto-fonts-cjk
			noto-fonts-emoji
			liberation_ttf
			fira-code
			fira-code-symbols
			mplus-outline-fonts.githubRelease
			dina-font
			proggyfonts
			tailscale
		];
	};
}
