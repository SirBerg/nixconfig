{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.utils;
in
{
	options.boerg.packages.utils.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
		environment.systemPackages = with pkgs;[
            git
            wget
            tree
            unzip
            killall
            neofetch
            nmap
            btop
            docker-compose
            dig
            coolercontrol.coolercontrol-gui
            coolercontrol.coolercontrol-ui-data
            rclone
            xsel
            pciutils
            clinfo
            cifs-utils
            tmux
            lnav
            kitty
            rclone
            networkmanagerapplet
            nodejs
            traceroute
            wine64
            winetricks
            wineWowPackages.waylandFull
            coolercontrol.coolercontrol-liqctld
            coolercontrol.coolercontrold
            mangohud
            mplayer
            #gitbutler
            audacity
            multiviewer-for-f1
            attic-client
            jdk21
            gimp
            icu
            vscode-fhs
            protontricks
            lutris
		obs-studio
		vesktop
		];
		programs.coolercontrol.nvidiaSupport = true;
		programs.coolercontrol.enable = true;
        programs.steam = {
          enable = true;
          remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
          dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
          localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
        };
    };
}
