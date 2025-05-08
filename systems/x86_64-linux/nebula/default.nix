# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boerg = {
    services = {
      ssh.enable = true;
    };
    packages = {
      common.enable = true;
    };
    users = {
      berg = {
        isGuiUser = false;
        isSudoUser = true;
        git = {
          userName = "SirBerg";
          userEmail = "benno@boerg.co";
        };
        isDockerUser = true;
        extraGroups = [ "nixbld" "docker" ];
        authorizedKeys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhIrnXyYZ63yo/Y2XqiPiQ5uOviP6pVYLxx+Iyuo5DjiGsjR/FOG6wWdeTtlpMbEinqFBtq5d3wGqDtQBak9IDsqJ/u9khT7fsQiykrxIxemSv8bCzvXeh9rnFuAA6cjvPwL9Ie7g38W7GHP5aJjLMx6vUiRHafD+5T37uYK2VUhVG8XTbygS4C+k3DOQ36R+whHoLeu0okFhTt6nu2IX2qx/j8kllOwCVq7AjbPAQJmDPvEOVZONHRDSM0XFEiwkdnF0qwtHGzmYARYhL1Tpp/SuSq7EsJvu0UrYl+hJpV+4VbU08M7YsEEwHAQkolKxgJZf6x/A8cliAIoMnrAoZ0a15/GBgadmuqUy1RkR0Lfr5ta4xEriqeYt+uiaZ84hCSVq+k6MX1P0b23ytqdOJXrvjsasDfPuTojvg+pyylZRj2Fz+MlVM3SnEzfvpKGuY7wbVxtg7kcKdL3wXqJZoUoIYGgr1buxO6iLa2784xfUdSK5iu1YA+B2tpxSxSz8="
        ];
      };
    };
    cache.enable = true;
    # Sets system labels and other basic configurations
    docker = {
      enable = true;
      containers = {
        traefik = {
          enable = true;
        };
        monitoring = {
          enable = true;
        };
        grafana = {
          enable = true;
        };
        adguard = {
          enable = true;
        };
      };

    };
    config.standard.enable = true;
  };
  services.resolved.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "24.05";
}
