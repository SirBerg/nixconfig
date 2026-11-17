{config,lib,pkgs,inputs,...}:

{
	imports = [
		./disko.nix
		./hardware-configuration.nix
	];

	boerg = {
		packages.utils.core.enable = true;
		packages.neovim.enable = true;
		users.berg = {
			isSudoUser = true;
			isKvmUser = true;
			authorizedKeys = [
				"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhIrnXyYZ63yo/Y2XqiPiQ5uOviP6pVYLxx+Iyuo5DjiGsjR/FOG6wWdeTtlpMbEinqFBtq5d3wGqDtQBak9IDsqJ/u9khT7fsQiykrxIxemSv8bCzvXeh9rnFuAA6cjvPwL9Ie7g38W7GHP5aJjLMx6vUiRHafD+5T37uYK2VUhVG8XTbygS4C+k3DOQ36R+whHoLeu0okFhTt6nu2IX2qx/j8kllOwCVq7AjbPAQJmDPvEOVZONHRDSM0XFEiwkdnF0qwtHGzmYARYhL1Tpp/SuSq7EsJvu0UrYl+hJpV+4VbU08M7YsEEwHAQkolKxgJZf6x/A8cliAIoMnrAoZ0a15/GBgadmuqUy1RkR0Lfr5ta4xEriqeYt+uiaZ84hCSVq+k6MX1P0b23ytqdOJXrvjsasDfPuTojvg+pyylZRj2Fz+MlVM3SnEzfvpKGuY7wbVxtg7kcKdL3wXqJZoUoIYGgr1buxO6iLa2784xfUdSK5iu1YA+B2tpxSxSz8="
			];
			git = {
				userName = "SirBerg";
				userEmail = "benno@boerg.co";
			};
			initialPassword = "boerg";
		};
		services.ssh.enable = true;
		virt.libvirt.enable = true;
		docker.enable = true;
		packages.tailscale.enable = true;
	};

	nix.settings.trusted-users = [ "root" "@wheel" ];

	boot.loader.systemd-boot = {
		enable = true;
		configurationLimit = 20;
	};

	boot.loader.efi.canTouchEfiVariables = false;

	boot.supportedFilesystems = [ "zfs" ];
	boot.zfs.forceImportRoot = false;

	# Cap ARC at 16GiB so the game VM and containers get their RAM
	boot.kernelParams = [ "zfs.zfs_arc_max=17179869184" ];

	services.zfs = {
		autoScrub.enable = true;
		autoScrub.interval = "monthly";
		trim.enable = true;
		autoSnapshot = {
			enable = true;
			flags = "-k -p --utc";
			frequent = 0;
			hourly = 24;
			daily = 14;
      			weekly = 8;
      			monthly = 6;
		};
	};

	networking.hostId = "0f848a9e";

	networking.useNetworkd = true;
	networking.useDHCP = false;
	systemd.network = {
		enable = true;
		networks."10-uplink" = {
			matchConfig.MACAddress = "90:1b:0e:fe:89:ad";
			networkConfig.DHCP = "ipv4";
			address = [ "2a01:4f8:231:225b::2/64" ];
			routes = [ {Gateway = "fe80::1";}];
			linkConfig.RequiredForOnline = "routable";
		};
	};

	networking.firewall = {
		enable = true;
		allowedTCPPorts = [22 80 443];
		allowedUDPPorts = [21820 51820];
	};

	services.restic.server = {
		enable = true;
		dataDir = "/tank/backups/restic";
		appendOnly = true;
		privateRepos = true;
		prometheus = true;
		listenAddress = "100.124.0.1:8000";
	};

	time.timeZone = "Europe/Berlin";
	i18n.defaultLocale = "en_US.UTF-8";
	console.keyMap = "de";
	programs.zsh.enable = true;
	hardware.cpu.intel.updateMicrocode = true;

	system.stateVersion = "26.05";
}
