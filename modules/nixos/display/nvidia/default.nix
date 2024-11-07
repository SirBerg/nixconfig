# Enable the Nvidia Drivers 
{ options, config, lib, pkgs, inputs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.display.nvidia;
in
{

	options.boerg.display.nvidia.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
		hardware.graphics = {
			enable = true;
		};
		hardware.opengl = {
			enable = true;
		};
		services.xserver.videoDrivers = ["nvidia"];
		hardware.nvidia = {
			#Sets the Nvidia Driver thing 
			package = config.boot.kernelPackages.nvidiaPackages.stable;
			#Required as per https://nixos.wiki/wiki/Nvidia
			modesetting.enable = true;
			powerManagement.enable = false;
			open = false;

			nvidiaSettings = true;
		};
	};
}
