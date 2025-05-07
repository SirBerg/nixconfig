# Enable Hyprland and enable gpu acceleration
{ options, config, lib, pkgs, inputs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.display.laptop;
in
{

  options.boerg.display.laptop.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    # Enables the Hyprland Package
    environment.systemPackages = with pkgs;
      [
        # Hyprland itself
        hyprland

        # Some stuff to make hyprland look nice and make it usable
        wofi
        swaylock
        hyprpaper

      ];
    programs.hyprland.enable = true;
    # Enable the xwayland support in hyprland
    programs.hyprland.xwayland.enable = true;

    # Enable the gpu acceleration (Idk why but this wasn't set)
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vpl-gpu-rt
      ];
    };
  };
}
