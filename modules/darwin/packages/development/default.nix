{ config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.packages.development;
in
{
  options.boerg.packages.development.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {

    environment.systemPackages = with pkgs;
      [
        jetbrains.webstorm
        jetbrains.clion
        jetbrains.rust-rover
        jetbrains.datagrip
        jetbrains.goland
        jetbrains.phpstorm
        jetbrains.idea-ultimate
        jetbrains-toolbox
        gcc
        rustup
        postman
        go
        air
        ninja
        cmake
        bun
        jetbrains.goland
        vscode
        php
      ];

  };
}
