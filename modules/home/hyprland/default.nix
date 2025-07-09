{ options, config, lib, ... }:
let
  cfg = config.boerg.hyprland;
  variant = config.boerg.hyprland.variant;
in
{
  options.boerg.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    variant = lib.mkOption {
      type = lib.types.enum [ "izanami" "other" ];
      default = "other";
    };
  };
  config = lib.mkIf cfg.enable {
    home.file.".config/hypr/hyprland.conf" = {
      enable = true;
      source = if cfg.variant == "izanami" then ./configs/izanami/hyprland.conf else ./configs/generic/hyprland.conf;
    };
    home.file.".config/hypr/hyprpaper.conf" = {
      enable = true;
      source = if cfg.variant == "izanami" then ./configs/izanami/hyprpaper.conf else ./configs/generic/hyprpaper.conf;
    };
  };
}
