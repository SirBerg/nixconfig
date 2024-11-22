{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.kdewallet;
in
{
	options.boerg.packages.kdewallet.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs;[
        			kdePackages.qtwayland
        			kdePackages.qtsvg
        			kdePackages.kauth
        			kdePackages.kio
        			kdePackages.kio-admin
        			kdePackages.kio-extras
        			kdePackages.kwallet-pam
        			kdePackages.kwallet
        			kdePackages.konsole
        			kdePackages.wayland
        			kdePackages.wayland-protocols
        			kdePackages.dolphin
        			kdePackages.kwalletmanager
		];
        qt.enable = true;

        xdg.portal.enable = true;
        xdg.portal.extraPortals = with pkgs; [
            kdePackages.kwallet
        ];

        #security.pam.services = {
        #    login.kwallet = {
        #        enable = true;
        #        package = pkgs.kdePackages.kwallet-pam;
        #    };
        #};
	};
}
