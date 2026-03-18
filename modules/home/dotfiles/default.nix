{ options, config, lib, ... }:
let
  cfg = config.boerg.dotfiles;
in
{
  options.boerg.dotfiles.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };

  config = lib.mkIf cfg.enable {
    home.file.".config/swaylock/config" = {
      enable = true;
      source = ./dotfiles/swaylock.conf;
    };
    home.file.".config/sway/config" = {
      enable = true;
      source = ./sway/config;
    };
    home.file.".config/tmux/tmux.conf" = {
      enable = true;
      source = ./dotfiles/tmux/tmux.conf;
    };
  };
}
