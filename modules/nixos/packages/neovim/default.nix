{ config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.packages.neovim;
in
{
  options.boerg.packages.neovim.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        # Mason dependencies
        go
        python3
      ];
    programs.nix-ld.enable = true;
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      configure = {
        customRC = (builtins.readFile ./init.vim);

        packages.nix = {
          start = with pkgs.vimPlugins; [
            mason-nvim
            markdown-preview-nvim
            rainbow
            auto-pairs
            vim-gitgutter
            nvim-tree-lua
            (nvim-treesitter.withPlugins (p: with p; [ tree-sitter-nix typescript ]))
            #tokyonight-nvim
            lsp-zero-nvim
            nvim-lspconfig
            nvim-cmp
            cmp-nvim-lsp
            mason-lspconfig-nvim
            mason-tool-installer-nvim
            vim-monokai-pro
          ];
        };
      };
    };
  };
}



