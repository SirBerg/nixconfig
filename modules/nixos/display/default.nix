# Enable Hyprland and enable gpu acceleration
{ options, config, lib, pkgs, inputs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.display.laptop;
in
{

	options.boerg.display.laptop.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
		# Enables the Hyprland Package
		environment.systemPackages = with pkgs;
		[
			# Hyprland itself
			hyprland

			# Install some dependencies to make it look nice
			waybar
			wofi
			swaylock
			pipewire
			libgtop
			bluez
			grimblast
			gpu-screen-recorder
			hyprpicker
			btop
			networkmanager
			matugen
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
			matugen
			ags
			gtk3
		];
		programs.hyprland.enable = true;
		# Enable the xwayland support in hyprland
		programs.hyprland.xwayland.enable = true;
		# Enable the additional programs
		programs.waybar.enable = true;
		


		# Enable the gpu acceleration (Idk why but this wasn't set)
		hardware.graphics = {
			enable = true;
			extraPackages = with pkgs; [
				vpl-gpu-rt
			];
		};		
	};
}
