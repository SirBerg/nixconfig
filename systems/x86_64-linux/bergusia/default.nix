{ config, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boerg = {
    packages = {
      common.enable = true;
      work.enable = true;
      utils.core.enable = true;
      utils.extended.enable = true;
    };
    display =
      {
        sway.enable = true;
      };
    users = {
      berg = {
        isGuiUser = true;
        isSudoUser = true;
        git = {
          userName = "SirBerg";
          userEmail = "benno@boerg.co";
        };
        isDockerUser = true;
        extraGroups = [ "nixbld" "docker" "video" ];
      };
    };
    cache.enable = true;
    docker = {
      enable = true;
    };
    config.standard.enable = true;
  };
  services.resolved.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "25.05";
}
