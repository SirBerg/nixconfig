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
  boot.zfs.extraPools = [ "solaris" "appdata" ];
  boot.zfs.requestEncryptionCredentials = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems = {
#    "/mnt/unraid" = {
#      device = "/mnt/disks/disk1:/mnt/disks/disk2";
#      fsType = "fuse.mergerfs";
#      options = [
#        "defaults"
#        "allow_other"
#        "use_ino"
#        "cache.files=partial"      
#        "dropcacheonclose=true"    
#        "category.create=mfs"      
#        "moveonenospc=true"        
#        "minfreespace=20G"         
#        "fsname=mergerfs"          
#        "nofail"
#      ];
#    };
    "/" = {
      device = "/dev/disk/by-uuid/47b80bdd-2908-485d-9524-1db9ff53fc33";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/2352-A074";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/7a0f587a-1c1f-4e6b-99b7-f792789883ac";
      fsType = "btrfs";
    };
  };


  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
