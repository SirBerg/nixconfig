{ config, lib, ... }:

with lib;
let
  cfg = config.boerg.kubernetes;
in
{
  ### options ############################################################
  options.boerg.kubernetes.enable = mkOption {
    type = lib.types.bool;
    default = false;
  };

  options.boerg.kubernetes.role = mkOption {
    type = lib.types.enum [ "server" "agent" ];
    default = "agent";
  };

  options.boerg.kubernetes.init = mkOption {
    type = lib.types.bool;
    default = false;
  };

  options.boerg.kubernetes.address = mkOption { type = lib.types.str; };

  ### config #############################################################
  config = mkIf cfg.enable (
    {
      networking.firewall.allowedTCPPorts = [ 6443 2379 2380 10250 ];
      networking.firewall.allowedUDPPorts = [ 8472 ];

      services.k3s = {
        enable      = true;
        role        = cfg.role;
        token       = "SundanceClusterSecret"; # TODO: put this in a secret
        clusterInit = cfg.init;
      };
    }

    # Add serverAddr only for agents
    // mkIf (cfg.role == "agent") {
      networking.firewall.allowedTCPPorts = [ 6443 2379 2380 10250 ];
      networking.firewall.allowedUDPPorts = [ 8472 ];
      services.k3s = {
        enable      = true;
        role        = cfg.role;
        token       = "SundanceClusterSecret"; # TODO: put this in a secret
        clusterInit = cfg.init;
	serverAddr = "https://10.124.0.2:6443";
      };
     }
  );
}
