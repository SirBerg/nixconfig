{ config, pkgs, inputs, ...}:

{
	imports = [ ./hardware-configuration.nix];

	boerg = {
		packages: {
			utils.core.enable = true
		};
		users = {
			berg = {
				isGuiUser = true;
				isSudoUser = true;
				isKvmUser = true;
				git = {
					userName = "SirBerg";
					userEmail = "benno@boerg.co";
				};
			};
		};
		virt.libvirt.enable = true;
		services.ssh.enable = true;
		docker = {
			enable = true;
		};
	}

	boot.supportedFilesystems = [ "zfs" ];
	networking.hostId = "3161faaa"
	services.zfs.autoScrub.enable = true;
	services.zfs.autoSnapshot.enable = true;

	time.timeZone = "Europe/Berlin";
	networking.networkmanager.enable = true;

	console.keyMap = "de";
  	security.rtkit.enable = true;

  	nixpkgs.config.allowUnfree = true;

	environment.systemPackages = with pkgs; [
      		coolercontrol.coolercontrold
		coolercontrol.coolercontrol-gui
		coolercontrol.coolercontrol-ui-data
	];

	system.stateVersion = "25.11";
}
