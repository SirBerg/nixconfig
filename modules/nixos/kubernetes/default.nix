#Common Nix Packages
{ config, lib, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.kubernetes;
in
{
  options.boerg.kubernetes.enable = mkOption {
    type = bool;
    default = false;
  };
  options.boerg.kubernetes.role = mkOption {
    type = enum [ "server" "agent" ];
    default = "agent";
  };

  options.boerg.kubernetes.init = mkOption {
    type = bool;
    default = false;
  };
  options.boerg.kubernetes.address = mkOption {
    type = str;
  };
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      6443
      2379
      2380
      10250
    ];
    networking.firewall.allowedUDPPorts = [
      8472
    ];


    services.k3s = {
      enable = true;
      role = cfg.role;
      token = "SundanceClusterSecret"; #Change this later ;)
      clusterInit = cfg.init;
    };

    #mkIf cfg.init != true {
    #    services.k3s.serverAddr = "https://10.124.0.2:6443";
    #};
  };
}
