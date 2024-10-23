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
			kdePackages.qtwayland
			kdePackages.qtsvg
			kdePackages.kauth
			kdePackages.kio
			kdePackages.kio-admin
			kdePackages.kio-extras
			kdePackages.kwallet-pam
			kdePackages.kwallet
			
			kdePackages.wayland
			kdePackages.wayland-protocols
			nmap
			btop
			docker-compose
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
			traceroute
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
		#services.tailscale.interfaceName = "userspace-networking";
		services.tailscale.useRoutingFeatures = "both";
		networking.firewall.trustedInterfaces = [  "tailscale0" ];
		networking.firewall.checkReversePath = "loose";

		qt.enable = true;

		xdg.portal.enable = true;
		xdg.portal.extraPortals = with pkgs; [
			kdePackages.kwallet
		];

		security.pam.services = {
			login.kwallet = {
				enable = true;
				package = pkgs.kdePackages.kwallet-pam;
			};
		};
	};
}
