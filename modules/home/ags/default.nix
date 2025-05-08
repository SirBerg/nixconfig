{ options, config, lib, ... }:
let
  cfg = config.boerg.ags;
in
{
  options.boerg.ags.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
  };
  config = lib.mkIf cfg.enable {
    #programs.ags = {
    #  enable = true;
    #  # additional packages to add to gjs's runtime
    #  extraPackages = with pkgs; [
    #    gtksourceview
    #    webkitgtk
    #    accountsservice
    #  ];
    #};
  };
}
