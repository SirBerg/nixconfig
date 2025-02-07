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

    system.nixos.label = if (self ? rev) then "voyager.${self.shortRev}" else "voyager-dirty.${self.dirtyShortRev}";

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