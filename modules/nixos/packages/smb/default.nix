{ options, config, lib, pkgs, ...}:

with lib;
with lib.types;
let
	cfg = config.boerg.packages.samba;
in
{
	options.boerg.packages.samba.enable = mkOption {
		type = bool;
		default = false;
	};
	config = mkIf cfg.enable {
        services.samba = {
          enable = true;
          securityType = "user";
          openFirewall = true;
          settings = {
            global = {
              "workgroup" = "WORKGROUP";
              "server string" = "smbnix";
              "netbios name" = "smbnix";
              "security" = "user";
              #"use sendfile" = "yes";
              #"max protocol" = "smb2";
              # note: localhost is the ipv6 localhost ::1
              "hosts allow" = "0.0.0.0/0";
              "hosts deny" = "";
              "guest account" = "nobody";
              "map to guest" = "bad user";
            };
            "public" = {
              "path" = "/mnt/Shares/Public";
              "browseable" = "yes";
              "read only" = "yes";
              "guest ok" = "yes";
              "create mask" = "0644";
              "directory mask" = "0755";
            };
          };
        };
	};
}
