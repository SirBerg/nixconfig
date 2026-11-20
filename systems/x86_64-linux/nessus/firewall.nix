{ lib, ... }:

let
  # Source: https://www.cloudflare.com/ips/ (list last changed Sep 28, 2023)
  cloudflareV4 = [
    "173.245.48.0/20"
    "103.21.244.0/22"
    "103.22.200.0/22"
    "103.31.4.0/22"
    "141.101.64.0/18"
    "108.162.192.0/18"
    "190.93.240.0/20"
    "188.114.96.0/20"
    "197.234.240.0/22"
    "198.41.128.0/17"
    "162.158.0.0/15"
    "104.16.0.0/13"
    "104.24.0.0/14"
    "172.64.0.0/13"
    "131.0.72.0/22"
  ];

  cloudflareV6 = [
    "2400:cb00::/32"
    "2606:4700::/32"
    "2803:f800::/32"
    "2405:b500::/32"
    "2405:8100::/32"
    "2a06:98c0::/29"
    "2c0f:f248::/32"
  ];

  join = lib.concatStringsSep ", ";
in
{
  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;

    # Do NOT put 80/443 here, or they'd be open to everyone.
    # SSH is reachable via tailscale0 (trusted interface), so no public ports.
    allowedTCPPorts = [ ];
  };

  # 80/443 are published by Docker (gerbil) and get DNAT'd before the input
  # chain, so filter in prerouting ahead of Docker's dstnat (priority -100).
  networking.nftables.tables.cloudflare-only = {
    family = "inet";
    content = ''
      set cf4 { type ipv4_addr; flags interval; elements = { ${join cloudflareV4} } }
      set cf6 { type ipv6_addr; flags interval; elements = { ${join cloudflareV6} } }

      chain prerouting {
        type filter hook prerouting priority -150; policy accept;
        iifname "enp0s31f6" tcp dport { 80, 443 } ip  saddr != @cf4 drop
        iifname "enp0s31f6" tcp dport { 80, 443 } ip6 saddr != @cf6 drop
      }
    '';
  };
}
