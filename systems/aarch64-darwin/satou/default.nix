# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, self, ... }:
let
  configuration = { pkgs, ... }: {
    programs.zsh.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/Berlin";
    # Install firefox.
    programs.firefox.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      wget
    ];
    system.stateVersion = "24.05"; # Did you read the comment?
  };
in
{
    darwinConfigurations."satou" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."satou".pkgs;
}
