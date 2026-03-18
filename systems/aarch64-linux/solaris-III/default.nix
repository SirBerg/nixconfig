# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boerg = {
    packages = {
      common.enable = true;
    };
    users = {
      berg = {
        isGuiUser = true;
        isSudoUser = true;
        isKvmUser = true;
        initialPassword = "boerg";
        authorizedKeys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhIrnXyYZ63yo/Y2XqiPiQ5uOviP6pVYLxx+Iyuo5DjiGsjR/FOG6wWdeTtlpMbEinqFBtq5d3wGqDtQBak9IDsqJ/u9khT7fsQiykrxIxemSv8bCzvXeh9rnFuAA6cjvPwL9Ie7g38W7GHP5aJjLMx6vUiRHafD+5T37uYK2VUhVG8XTbygS4C+k3DOQ36R+whHoLeu0okFhTt6nu2IX2qx/j8kllOwCVq7AjbPAQJmDPvEOVZONHRDSM0XFEiwkdnF0qwtHGzmYARYhL1Tpp/SuSq7EsJvu0UrYl+hJpV+4VbU08M7YsEEwHAQkolKxgJZf6x/A8cliAIoMnrAoZ0a15/GBgadmuqUy1RkR0Lfr5ta4xEriqeYt+uiaZ84hCSVq+k6MX1P0b23ytqdOJXrvjsasDfPuTojvg+pyylZRj2Fz+MlVM3SnEzfvpKGuY7wbVxtg7kcKdL3wXqJZoUoIYGgr1buxO6iLa2784xfUdSK5iu1YA+B2tpxSxSz8="
        ];
        git = {
          userName = "SirBerg";
          userEmail = "benno@boerg.co";
        };
      };
    };
    config.standard.enable = true;
    services.ssh.enable = true;
    docker = {
      enable = true;
    };
  };

  programs.zsh.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  fonts.fontconfig.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.nftables.enable = true;
  # In configuration.nix
	environment.etc."geoip-update.sh" = {
	  mode = "0750";
	  text = ''
	    #!/usr/bin/env bash
	    set -euo pipefail

	    DB_URL="https://download.db-ip.com/free/dbip-country-lite-$(date +%Y-%m).csv.gz"
	    DB_FILE="/var/lib/geoip/dbip-country.csv"
	    COUNTRIES=("DE" "AT" "CH")

	    mkdir -p /var/lib/geoip
	    curl -sSL "$DB_URL" | gunzip > "$DB_FILE"

	    # Flush and recreate the geoip table
	    nft flush table inet geoip 2>/dev/null || true
	    nft delete table inet geoip 2>/dev/null || true
	    nft add table inet geoip
	    nft add chain inet geoip input \
	      '{ type filter hook input priority -100 ; policy drop ; }'

	    # Always allow loopback and established/related
	    nft add rule inet geoip input iif lo accept
	    nft add rule inet geoip input ct state established,related accept

	    for CC in "''${COUNTRIES[@]}"; do
	      SET="GEOIP_$CC"

	      # IPv4 set
	      nft add set inet geoip "$SET"_v4 \
		'{ type ipv4_addr ; flags interval ; auto-merge ; }'
	      # IPv6 set
	      nft add set inet geoip "$SET"_v6 \
		'{ type ipv6_addr ; flags interval ; auto-merge ; }'

	      # Populate sets from CSV
	      # CSV format: start_ip,end_ip,country_code
	      grep ",''${CC}$" "$DB_FILE" | while IFS=',' read -r start end cc; do
		if [[ "$start" == *:* ]]; then
		  nft add element inet geoip "$SET"_v6 "{ $start - $end }" 2>/dev/null || true
		else
		  nft add element inet geoip "$SET"_v4 "{ $start - $end }" 2>/dev/null || true
		fi
	      done

	      # Accept traffic from allowed countries
	      nft add rule inet geoip input ip saddr "@''${SET}_v4" accept
	      nft add rule inet geoip input ip6 saddr "@''${SET}_v6" accept
	    done
	    # Always allow loopback and established/related
		nft add rule inet geoip input iif lo accept
		nft add rule inet geoip input ct state established,related accept

		# Allow private/management networks (Hetzner VNC, VPN, etc.)
		nft add rule inet geoip input ip saddr 10.0.0.0/8 accept
		nft add rule inet geoip input ip saddr 172.16.0.0/12 accept
		nft add rule inet geoip input ip saddr 192.168.0.0/16 accept
		nft add rule inet geoip input ip saddr 169.254.0.0/16 accept
		nft add rule inet geoip input ip6 saddr fe80::/10 accept

		# Your VPN network - replace with your actual VPN subnet
		nft add rule inet geoip input ip saddr 100.0.0.0/8 accept

	    echo "GeoIP update complete."
	  '';
	};

	systemd.services.geoip-update = {
	  description = "Update GeoIP nftables sets";
	  after = [ "network-online.target" ];
	  wants = [ "network-online.target" ];
	  serviceConfig = {
	    Type = "oneshot";
	    ExecStart = "/bin/sh /etc/geoip-update.sh";
	  };
	  # Run once at boot too
	  wantedBy = [ "multi-user.target" ];
	};

	systemd.timers.geoip-update = {
	  description = "Monthly GeoIP update";
	  wantedBy = [ "timers.target" ];
	  timerConfig = {
	    OnCalendar = "monthly";
	    Persistent = true;
	  };
	};
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure console keymap
  console.keyMap = "de";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  curl
  gzip
  gunzip
  nftables
  ];
boot.kernelParams = [ "console=tty1" ];
systemd.services."getty@tty1".enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
