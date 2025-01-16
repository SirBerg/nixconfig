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
	    #... and then Hyprpanel dependencies
        			pipewire
        			libgtop
        			bluez
        			grimblast
        			gpu-screen-recorder
        			hyprpicker
        			btop
        			networkmanager
        			wl-clipboard
        			swww
        			dart-sass
        			brightnessctl
        			gnome-bluetooth
        			hyprpanel
        			bun
        			gtop
        			fzf
        			hyprpicker
        			slurp
        			wf-recorder
        			wl-clipboard
        			wayshot
        			swappy
        			supergfxctl
        			fd
        			#matugen
        			ags
        			gtk3
	    ];
		fonts.packages = with pkgs; [
			  noto-fonts
			  noto-fonts-cjk-sans
			  noto-fonts-emoji
			  liberation_ttf
			  fira-code
			  fira-code-symbols
			  mplus-outline-fonts.githubRelease
			  dina-font
			  proggyfonts
			  jetbrains-mono
			  nerdfonts
			  notonoto
		];
		qt.enable = true;
	};
}



