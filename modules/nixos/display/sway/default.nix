{ config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.display.sway;
in
{

  options.boerg.display.sway.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    programs.xwayland.enable = true;
    environment.systemPackages = with pkgs;[
      xorg.libX11
      xorg.libxcb
      xorg.libXi
      kitty
      gsettings-qt
      dmenu
      swaylock
    ];

    programs.sway =
      {
        enable = true;
        wrapperFeatures.gtk = true;
      };
    programs.light.enable = true;
    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "de";
      variant = "";
    };
  };
}
