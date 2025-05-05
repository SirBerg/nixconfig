# Enable Hyprland and enable gpu accelerationConnoisseur
{ options, config, lib, pkgs, inputs, self, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.config.standard;
in
{

	options.boerg.config.standard.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
        system.nixos.label = if (self ? rev) then "master.${self.shortRev}" else "master-dirty.${self.dirtyShortRev}";
        # Bootloader.
        boot.loader.systemd-boot.enable = true;
        boot.kernelPackages = pkgs.linuxPackages_latest;
        boot.loader.efi.canTouchEfiVariables = true;

        # Enable networking
        networking.networkmanager.enable = true;

        # Set time zone.
        time.timeZone = "Europe/Berlin";

        # Select internationalisation properties.
        i18n.defaultLocale = "en_US.UTF-8";

        i18n.extraLocaleSettings = {
            LC_ADDRESS = "de_DE.UTF-8";
            LC_IDENTIFICATION = "de_DE.UTF-8";
            LC_MEASUREMENT = "de_DE.UTF-8";
            LC_MONETARY = "de_DE.UTF-8";
            LC_NAME = "de_DE.UTF-8";
            LC_NUMERIC = "de_DE.UTF-8";
            LC_PAPER = "de_DE.UTF-8";
            LC_TELEPHONE = "de_DE.UTF-8";
            LC_TIME = "de_DE.UTF-8";
        };
	};
}
