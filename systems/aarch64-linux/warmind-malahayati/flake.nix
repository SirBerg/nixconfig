{
  description = "Example Raspberry Pi 5 configuration flake";
    inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
      nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
      boerg.url = "github:SirBerg/nixconfig?ref=voyager";
    };

  nixConfig = {
    extra-substituters = [
      "https://nixos-raspberrypi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
    extra-experimental-features = [ "nix-command" "flakes" ];
  };

  outputs = { self, nixpkgs, nixos-raspberrypi, boerg }@inputs :
    {
      nixosConfigurations = {
        warmind-malahayati = nixos-raspberrypi.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ({...}: {
              imports = [
                nixos-raspberrypi.nixosModules.raspberry-pi-5.base
                nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
		boerg.nixosModules."packages/utils/core"
		boerg.nixosModules."services/ssh"
		boerg.nixosModules.kubernetes
		boerg.nixosModules."packages/common"
		boerg.nixosModules."packages/browser/firefox"
		boerg.nixosModules."packages/browser/brave"
		boerg.nixosModules."packages/neovim"
		boerg.nixosModules."packages/tailscale"
              ];
            })
            ({ ... }: {
              networking.hostName = "warmind-charlemagne";
              users.users.berg = {
                initialPassword = "boerg";
                isNormalUser = true;
                extraGroups = [
                  "wheel" "docker" "sudo"
                ];
		openssh.authorizedKeys.keys = [
		  "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhIrnXyYZ63yo/Y2XqiPiQ5uOviP6pVYLxx+Iyuo5DjiGsjR/FOG6wWdeTtlpMbEinqFBtq5d3wGqDtQBak9IDsqJ/u9khT7fsQiykrxIxemSv8bCzvXeh9rnFuAA6cjvPwL9Ie7g38W7GHP5aJjLMx6vUiRHafD+5T37uYK2VUhVG8XTbygS4C+k3DOQ36R+whHoLeu0okFhTt6nu2IX2qx/j8kllOwCVq7AjbPAQJmDPvEOVZONHRDSM0XFEiwkdnF0qwtHGzmYARYhL1Tpp/SuSq7EsJvu0UrYl+hJpV+4VbU08M7YsEEwHAQkolKxgJZf6x/A8cliAIoMnrAoZ0a15/GBgadmuqUy1RkR0Lfr5ta4xEriqeYt+uiaZ84hCSVq+k6MX1P0b23ytqdOJXrvjsasDfPuTojvg+pyylZRj2Fz+MlVM3SnEzfvpKGuY7wbVxtg7kcKdL3wXqJZoUoIYGgr1buxO6iLa2784xfUdSK5iu1YA+B2tpxSxSz8="
		];
              };
	      boerg.kubernetes = {
		enable = true;
		role = "agent";
		address = "10.124.0.2";
	      };
              boerg.packages.utils.core.enable = true;
	      boerg.packages.common.enable = true;
	      boerg.services.ssh.enable = true;
	      networking = {
		      interfaces = {
			      end0 = {
				      ipv4.addresses = [{
				      	address = "10.124.0.6";
					prefixLength = 24;
				      }];
				      useDHCP = false;
			      };		      	
		      };
		      defaultGateway = {
		      	address = "10.124.0.1";
			interface = "end0";
		      };
		      nameservers = [
		      	"1.1.1.1"
			"1.0.0.1"
		      ];
	      };
	      hardware.raspberry-pi.config = {
		      all = {
			      options = {
				      cgroup_enable = {
				      	enable = true;
					value = "memory";
				      };	
			      };
		      };
	      };
	      boot.kernelParams = ["cgroup_enable=memory"];
            })

            ({ ... }: {
              fileSystems = {
                "/boot/firmware" = {
                  device = "/dev/disk/by-uuid/2175-794E";
                  fsType = "vfat";
                  options = [
                    "noatime"
                    "noauto"
                    "x-systemd.automount"
                    "x-systemd.idle-timeout=1min"
                  ];
                };
                "/" = {
                  device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
                  fsType = "ext4";
                  options = [ "noatime" ];
                };
              };
            })
          ];
        };
      };
    };
}
