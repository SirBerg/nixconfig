#Common Nix Packages
{ options, config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.virt.vmware;
in
{
  options.boerg.virt.vmware.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        vmware-workstation
      ];
  };
}
