let
	nvmeBoot = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB512HAJQ-00000_S3W8NX0M278373";
	nvmeFast = "/dev/disk/by-id/nvme-SAMSUNG_MZVLB512HAJQ-00000_S3W8NX0M284022";
	hdd1 = "/dev/disk/by-id/ata-TOSHIBA_MG08ACA16TEY_X1E0A0LXFVNG";
	hdd2 = "/dev/disk/by-id/ata-TOSHIBA_MG08ACA16TEY_X1K0A008FVNG";

	zfsRootOpts = {
		compression = "zstd";
		atime = "off";
		xattr = "sa";
		acltype = "posixacl";
		mountpoint = "none";
		"com.sun:auto-snapshot" = "false";
	};

	tankDisk = device: {
		type = "disk";
		inherit device;
		content = {
			type = "gpt";
			partitions.zfs = {
				size = "100%";
				content = {
					type = "zfs";
					pool = "tank";
				};
			};
		};
	};
in
{
  disko.devices = {
    disk = {
      boot = {
        type = "disk";
        device = nvmeBoot;
        content = {
          type = "gpt";
          partitions = {
            # Legacy BIOS: GRUB embeds its core image here. disko adds this
            # disk to boot.loader.grub.devices automatically.
            bios = {
              size = "1M";
              type = "EF02";
              priority = 1;
            };
            ESP = {
              size = "1G";
              type = "EF00";
              priority = 2;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "@root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@log" = {
                    mountpoint = "/var/log";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };
          };
        };
      };

      fast = {
        type = "disk";
        device = nvmeFast;
        content = {
          type = "gpt";
          partitions.zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "fast";
            };
          };
        };
      };

      hdd1 = tankDisk hdd1;
      hdd2 = tankDisk hdd2;
    };

    zpool = {
      tank = {
        type = "zpool";
        mode = "mirror";
        options.ashift = "12";
        rootFsOptions = zfsRootOpts;
        datasets = {
          # restic repos etc. -- the data that actually matters
          backups = {
            type = "zfs_fs";
            mountpoint = "/tank/backups";
            options = {
              recordsize = "1M";
              "com.sun:auto-snapshot" = "true";
	      mountpoint = "legacy";
            };
          };
          # replaceable stuff (YouTube archive, ...) -- NOT backed up by restic
          archive = {
            type = "zfs_fs";
            mountpoint = "/tank/archive";
            options = {
              recordsize = "1M";
              "com.sun:auto-snapshot" = "true";
	      mountpoint = "legacy";
            };
          };
          # Keeps ~5% free so the pool can never be filled to 100%
          # (a full ZFS pool is very hard to recover). Adjust as you like.
          reserved = {
            type = "zfs_fs";
            options = {
              mountpoint = "none";
              refreservation = "700G";
            };
          };
        };
      };

      fast = {
        type = "zpool";
        options.ashift = "12";
        rootFsOptions = zfsRootOpts;
        datasets = {
          # Game-server VM disks (qcow2 or zvols under fast/vms)
          vms = {
            type = "zfs_fs";
            mountpoint = "/var/lib/libvirt/images";
            options."com.sun:auto-snapshot" = "true";
	    options.mountpoint = "legacy";
          };
          # Docker data (Pangolin, Grafana, ...)
          docker = {
            type = "zfs_fs";
            mountpoint = "/var/lib/docker";
	    options.mountpoint = "legacy";
          };
        };
      };
    };
  };
}
