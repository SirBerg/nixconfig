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
	jetbrains.pycharm-professional
	jetbrains.phpstorm
	jetbrains.idea-ultimate
	jetbrains.gateway
        jetbrains.goland
        jetbrains-toolbox
	android-studio
	python314
	python313Packages.pip
	python313Packages.notebook
	virtualenv
        coder
        gcc
        rustup
        postman
        libcap
        go
        hoppscotch
        air
        ninja
        cmake
        gnumake42
        bun
        vscode
        #netbeans
        #bluej
        ghidra-bin
        surrealist
        (pkgs.jdk21.override { enableJavaFX = true; })
        kubectl
#        scenebuilder
        hellwal
        rustc
        cargo
      ];


    services.solaar = {
      enable = true;
      window = "hide";
      extraArgs = "--restart-on-wake-up";
    };
  };
}
