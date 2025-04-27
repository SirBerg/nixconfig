{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = true;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.networkmanager.enable = true;
  boerg = {
    packages = {
      common.enable = true;
      utils.core.enable = true;
    };
    services = {
        ssh.enable = true;
    };
    users = {
      "berg" = {
        isGuiUser = true;
        isSudoUser = true;
        uid = 1000;
        initialPassword = "boerg";
        authorizedKeys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhIrnXyYZ63yo/Y2XqiPiQ5uOviP6pVYLxx+Iyuo5DjiGsjR/FOG6wWdeTtlpMbEinqFBtq5d3wGqDtQBak9IDsqJ/u9khT7fsQiykrxIxemSv8bCzvXeh9rnFuAA6cjvPwL9Ie7g38W7GHP5aJjLMx6vUiRHafD+5T37uYK2VUhVG8XTbygS4C+k3DOQ36R+whHoLeu0okFhTt6nu2IX2qx/j8kllOwCVq7AjbPAQJmDPvEOVZONHRDSM0XFEiwkdnF0qwtHGzmYARYhL1Tpp/SuSq7EsJvu0UrYl+hJpV+4VbU08M7YsEEwHAQkolKxgJZf6x/A8cliAIoMnrAoZ0a15/GBgadmuqUy1RkR0Lfr5ta4xEriqeYt+uiaZ84hCSVq+k6MX1P0b23ytqdOJXrvjsasDfPuTojvg+pyylZRj2Fz+MlVM3SnEzfvpKGuY7wbVxtg7kcKdL3wXqJZoUoIYGgr1buxO6iLa2784xfUdSK5iu1YA+B2tpxSxSz8="
        ];
      };
    };
    config.core.enable = true;
    kubernetes = {
        enable = true;
        role = "server";
        address = "10.124.0.4";
        init = true;
    };
    docker = {
        enable = true;
	};
  };
  services.k3s.serverAddr = "https://10.124.0.2:6443";
    networking = {
        interfaces = {
        end0 = {
            ipv4.addresses = [{
                  address = "10.124.0.4";
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
            "1.1.1.1" "1.0.0.1"
        ];
    };

  system.stateVersion = "24.11"; # Did you read the comment?
}
