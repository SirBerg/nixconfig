#Common Nix Packages
{ config, lib, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.helpers.vmware;
in
{
  options.boerg.helpers.vmware.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    # enable vmware guest additions
    virtualisation.vmware.guest.enable = true;
  };
}
