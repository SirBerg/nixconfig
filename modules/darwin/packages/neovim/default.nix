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
        neovim
      ];

    programs.nixvim = {

      enable = true;
      viAlias = true;
      enableMan = true;
      vimAlias = true;
      extraConfigLua = ''
	${builtins.readFile ./init.lua}
      '';
      extraPlugins = with pkgs.vimPlugins; [
      	telescope-z-nvim
	nvim-lspconfig
	mason-nvim
	mason-lspconfig-nvim
	mason-tool-installer-nvim
	nvim-cmp
	cmp-buffer
	cmp-nvim-lsp
	cmp-path
	luasnip
	lualine-nvim
	nvim-treesitter
	which-key-nvim
	symbols-outline-nvim
	vim-illuminate
	nvim-autopairs
	gitsigns-nvim
	indent-blankline-nvim
	bufferline-nvim
      ];
    };

  };
}



