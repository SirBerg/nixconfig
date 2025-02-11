# Malahayati system configuration (Model: Raspberry Pi 4b)
{ config, pkgs, lib, self, ... }:
{
    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
        ];
    hardware = {
        raspberry-pi."4".apply-overlays-dtmerge.enable = true;
        deviceTree = {
            enable = true;
            filter = "*rpi-4-*.dtb";
        };
    };

    boerg = {
        packages = {
            common.enable = true;
            browser.firefox.enable = false;
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
                authorizedKeys = [
                    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhIrnXyYZ63yo/Y2XqiPiQ5uOviP6pVYLxx+Iyuo5DjiGsjR/FOG6wWdeTtlpMbEinqFBtq5d3wGqDtQBak9IDsqJ/u9khT7fsQiykrxIxemSv8bCzvXeh9rnFuAA6cjvPwL9Ie7g38W7GHP5aJjLMx6vUiRHafD+5T37uYK2VUhVG8XTbygS4C+k3DOQ36R+whHoLeu0okFhTt6nu2IX2qx/j8kllOwCVq7AjbPAQJmDPvEOVZONHRDSM0XFEiwkdnF0qwtHGzmYARYhL1Tpp/SuSq7EsJvu0UrYl+hJpV+4VbU08M7YsEEwHAQkolKxgJZf6x/A8cliAIoMnrAoZ0a15/GBgadmuqUy1RkR0Lfr5ta4xEriqeYt+uiaZ84hCSVq+k6MX1P0b23ytqdOJXrvjsasDfPuTojvg+pyylZRj2Fz+MlVM3SnEzfvpKGuY7wbVxtg7kcKdL3wXqJZoUoIYGgr1buxO6iLa2784xfUdSK5iu1YA+B2tpxSxSz8="
                ];
             };
        };
        cache.enable = true;
        virt.docker.enable = true;
        standard.config.enable = true;
    };

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    console.enable = true;

    # Install
    environment.systemPackages = with pkgs; [
        libraspberrypi
        raspberrypi-eeprom
    ];

    # Basic networking
    networking.networkmanager.enable = true;
    # Prevent host becoming unreachable on wifi after some time.
    networking.networkmanager.wifi.powersave = false;
    system.stateVersion = "23.11";
}