{ config, pkgs, inputs, ...}:

{
	imports = [ ./hardware-configuration.nix ./cron.nix];
	boerg = {
		display.nvidia.enable = true;
		packages =  {
			utils.core.enable = true;
			neovim.enable = true;
		};
		users = {
			berg = {
        isGuiUser = true;
        isSudoUser = true;
        isKvmUser = true;
        initialPassword = "boerg";
        authorizedKeys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhIrnXyYZ63yo/Y2XqiPiQ5uOviP6pVYLxx+Iyuo5DjiGsjR/FOG6wWdeTtlpMbEinqFBtq5d3wGqDtQBak9IDsqJ/u9khT7fsQiykrxIxemSv8bCzvXeh9rnFuAA6cjvPwL9Ie7g38W7GHP5aJjLMx6vUiRHafD+5T37uYK2VUhVG8XTbygS4C+k3DOQ36R+whHoLeu0okFhTt6nu2IX2qx/j8kllOwCVq7AjbPAQJmDPvEOVZONHRDSM0XFEiwkdnF0qwtHGzmYARYhL1Tpp/SuSq7EsJvu0UrYl+hJpV+4VbU08M7YsEEwHAQkolKxgJZf6x/A8cliAIoMnrAoZ0a15/GBgadmuqUy1RkR0Lfr5ta4xEriqeYt+uiaZ84hCSVq+k6MX1P0b23ytqdOJXrvjsasDfPuTojvg+pyylZRj2Fz+MlVM3SnEzfvpKGuY7wbVxtg7kcKdL3wXqJZoUoIYGgr1buxO6iLa2784xfUdSK5iu1YA+B2tpxSxSz8="
        ];
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
		mergerfs
		nvidia-container-toolkit
		tailscale
	];
	services.tailscale = {
		enable = true;
		useRoutingFeatures = "both";
	};
	programs.zsh.enable = true;
	networking = {
		hostId = "3161faaa";
		networkmanager.enable = true;
		interfaces = {
			"enp42s0" = {
				ipv4.addresses = [{
					address = "10.255.0.2";
					prefixLength = 24;
				}];
				useDHCP = false;
			};
		};
		defaultGateway = {
			address = "10.255.0.1";
			interface = "enp42s0";
		};
		nameservers = [
			"9.9.9.9"
			"149.112.112.112"
		];
	};
	system.stateVersion = "25.11";

	services.samba = {
		enable = true;
		securityType = "user";
		openFirewall = true;
		settings = {
			"benno" = {
				"path" = "/solaris/user/benno";
				"browseable" = "no";
				"read only" = "no";
				"guest ok" = "no";
				"create mask" = "0644";
				"directory mask" = "0755";
				"force user" = "benno";
			};      		
			"edgar" = {
				"path" = "/solaris/user/edgar";
				"browseable" = "no";
				"read only" = "no";
				"guest ok" = "no";
				"create mask" = "0644";
				"directory mask" = "0755";
				"force user" = "edgar";
			};
		};
	};

	services.samba-wsdd = {
		enable = true;
		openFirewall = true;
	};

}
