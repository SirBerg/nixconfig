{ config, lib, pkgs, modulesPath, self, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  system.nixos.label = if (self ? rev) then "voyager.${self.shortRev}" else "voyager-dirty.${self.dirtyShortRev}";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "zfs" "fuse" ];
  boot.zfs.forceImportRoot = false;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems = {
    "/mnt/solaris" = {
      device = "solaris";
      fsType = "zfs";
    };
    "/mnt/docker" = {
      device = "/dev/disk/by-uuid/something";
      fsType = "btrfs";
    };
    "/mnt/disks/disk1" = {
      device = "/dev/disk/by-uuid/unraid_disk_1";
      fsType = "xfs";
      options = [ "nofail" ];
    };
    "/mnt/disks/disk2" = {
      device = "/dev/disk/by-uuid/unraid_disk_2";
      fsType = "xfs";
      options = [ "nofail" ];
    };
    "/mnt/unraid" = {
      device = "/mnt/disks/disk1:/mnt/disks/disk2";
      fsType = "fuse.mergerfs";
      options = [
        "defaults"
        "allow_other"
        "use_ino"
        "cache.files=partial"      
        "dropcacheonclose=true"    
        "category.create=mfs"      
        "moveonenospc=true"        
        "minfreespace=20G"         
        "fsname=mergerfs"          
        "nofail"
      ];
    };
    "/" = {
      device = "/dev/disk/by-uuid/something";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/something";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/something";
      fsType = "btrfs";
    };
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
