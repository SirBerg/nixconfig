#Common Nix Packages
{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.common;
in
{
	options.boerg.packages.common.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs;
		[
			obsidian
			anki-bin
			spotify
			bluetuith
			zsh
		];
		boerg.packages.browser.firefox.enable = true;
		boerg.packages.browser.chromium.enable = true;
		boerg.packages.hyprpanel.enable = false;
		boerg.packages.neovim.enable = true;
		boerg.packages.utils.core.enable = true;
		boerg.packages.tailscale.enable = true;
		boerg.packages.kdewallet.enable = true;

		users.defaultUserShell = pkgs.zsh;
	};
}
