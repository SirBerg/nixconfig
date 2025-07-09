{ config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.display.hyprland;
in
{

  options.boerg.display.hyprland.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    programs.hyprland.enable = true;
    programs.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
      kitty
      hyprpaper
      waybar
      wofi
      swaylock
      hyprpanel
      hyprshot
      wireplumber
      libgtop
      bluez
      networkmanager
      dart-sass
      wl-clipboard
      upower
      gvfs
      gtksourceview3
      libsoup_3
    ];

    fonts.packages = with pkgs; [
      fira-code
      nerd-fonts.caskaydia-cove
    ];

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "de";
      variant = "";
    };
  };
}
