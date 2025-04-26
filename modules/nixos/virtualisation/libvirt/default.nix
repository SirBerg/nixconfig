{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.virt.libvirt;
in
{
	options.boerg.virt.libvirt.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
        environment.systemPackages = with pkgs;[
            virt-manager
            qemu
        ];
        virtualisation.libvirtd = {
            enable = true;
                qemu = {
                    package = pkgs.qemu_kvm;
                    runAsRoot = true;
                    swtpm.enable = true;
                        ovmf = {
                          enable = true;
                          packages = [(pkgs.OVMF.override {
                            secureBoot = true;
                            tpmSupport = true;
                          }).fd
                          pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
                          ];
                    };
            };
        };
        boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
        users.users.berg = {
            extraGroups = [ "docker" "libvirtd" ];
        };
	};
}
