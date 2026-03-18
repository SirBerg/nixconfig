{ config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.display.plasma;
in
{

  options.boerg.display.plasma.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
    programs.xwayland.enable = true;
    environment.systemPackages = [
      pkgs.xorg.libX11
      pkgs.xorg.libxcb
      pkgs.xorg.libXi
    ];
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "de";
      variant = "";
    };
  };
}
