{ config, pkgs, inputs, ...}:

{
	imports = [ ./hardware-configuration.nix];
	boerg = {
		packages =  {
			utils.core.enable = true;
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
	};

	services.zfs.autoScrub.enable = true;
	services.zfs.autoSnapshot.enable = true;

	time.timeZone = "Europe/Berlin";

	console.keyMap = "de";
  	security.rtkit.enable = true;

  	nixpkgs.config.allowUnfree = true;

	environment.systemPackages = with pkgs; [
      		coolercontrol.coolercontrold
		coolercontrol.coolercontrol-gui
		coolercontrol.coolercontrol-ui-data
	];
	programs.zsh.enable = true;
	networking = {
		hostId = "3161faaa";
		networkmanager.enable = true;
		interfaces = {
			end0 = {
				ipv4.addresses = [{
					address = "10.255.0.2";
					prefixLength = 24;
				}];
				useDHCP = false;
			};
		};
		defaultGateway = {
			address = "10.255.0.1";
			interface = "end0";
		};
		nameservers = [
			"9.9.9.9"
			"149.112.112.112"
		];
	};
	system.stateVersion = "25.11";

}
