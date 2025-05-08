#Common Nix Packages
{ config, lib, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.services.ssh;
in
{
  options.boerg.services.ssh.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = false;
        AllowUsers = null;
        UseDns = true;
        X11Forwarding = true;
        PermitRootLogin = "no";
      };
    };
  };
}
