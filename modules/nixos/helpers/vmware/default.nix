#Common Nix Packages
{ options, config, lib, pkgs, ... }:

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
