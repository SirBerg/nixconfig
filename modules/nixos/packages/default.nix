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
			jetbrains-mono
			mplus-outline-fonts.githubRelease
			dina-font
			proggyfonts
			tailscale
			kdePackages.dolphin
			rclone
			networkmanagerapplet
			kdePackages.kwalletmanager
			nodejs
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

		programs.neovim = {
			enable = true;
			defaultEditor = true;
			viAlias = true;
			vimAlias = true;
			withNodeJs = true;
			configure = {
				customRC = (builtins.readFile ./init.vim);
				
				packages.nix = {
					start = with pkgs.vimPlugins; [
						mason-nvim
						markdown-preview-nvim
						rainbow
						auto-pairs
						vim-gitgutter
						nvim-tree-lua
						(nvim-treesitter.withPlugins (p: with p; [ tree-sitter-nix typescript ]))
					];
				};
			};
			
		};
		services.tailscale.enable = true;
		# To fix dns exit-node issue
		services.tailscale.interfaceName = "userspace-networking";
	};
}
