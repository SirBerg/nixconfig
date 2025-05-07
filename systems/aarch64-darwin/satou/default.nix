# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, self, ... }:
{
    boerg = {
        packages = {
          common.enable = true;
          fonts.enable = true;
          steam.enable = true;
          development.enable = true;
          utils.extended.enable = true;
          utils.gui.enable = true;
        };
    };
      environment.systemPackages =
        [ pkgs.vim
        ];
      # Auto upgrade nix package
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      ids.gids.nixbld = 350;
      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
}
