{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.laptop;
in
{
	options.boerg.packages.laptop.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs;
		[
			obsidian
			anki-bin
			spotify
			chromium
			bluetuith
		];
        boerg.packages.hyprpanel.enable = false;
        boerg.packages.neovim.enable = true;
        boerg.packages.utils.enable = true;
        boerg.packages.development.enable = true;
        boerg.packages.tailscale.enable = true;
        boerg.packages.kdewallet.enable = true;
		services.solaar = {
			enable = true;
			window = "hide";
			extraArgs = "--restart-on-wake-up";
		};
	};
}
