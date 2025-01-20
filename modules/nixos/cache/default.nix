

      # Enable Hyprland and enable gpu acceleration
      { options, config, lib, pkgs, inputs, ...}:

      with lib;
      with lib.types;
      let
      	cfg = config.boerg.cache;
      in
      {
      	options.boerg.cache.enable = mkOption {
      		type = bool;
      		default = false;
      	};
      	config = mkIf cfg.enable {
          nix.settings = {
            substituters = [
              # nix community's cache server
              "https://nix-community.cachix.org"

              # own cache
              "https://attic.holypenguin.net/holynix"

             # Boerg
             "https://cache.boerg.co/boerg"
            ];
            trusted-substituters = [
              # nix community's cache server
              "https://nix-community.cachix.org"

              # own cache
              "https://attic.holypenguin.net/holynix"

             # Boerg
             "https://cache.boerg.co/boerg"
            ];
            trusted-public-keys = [
              # nix community's cache server public key
              "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="

              # own cache
              "holynix:Ucr2JJ5xLEy4hElI/SToX5klNe4I3wKgVIa2+b3lmYo="
             # Boerg
             "boerg:HWon/EZ25oRtGkW5WLIHcJOs2RxcW+TVKyy1LaYJFrY="
            ];
          };
      	};
      }
