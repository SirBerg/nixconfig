#Common Nix Packages
{ config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.services.hydra;
in
{
  options.boerg.services.hydra.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    services.hydra = {
      enable = true;
      hydraURL = "http://localhost:3000";
      notificationSender = "hydra@localhost";
      buildMachinesFiles = [ ];
      useSubstitutes = true;
      package = pkgs.hydra;
    };
  };
}
