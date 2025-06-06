#
# Whole file (with minor edits) from: https://github.com/Svenum/holynix/blob/main/modules/nixos/users/default.nix
#

{ options, config, lib, pkgs, ... }:

with lib;
with lib.types;
let
  cfg = config.boerg.users;

  mkUser = name: user: {
    isNormalUser = true;
    description = name;
    shell = mkIf (user.shell != null) user.shell;
    password = mkIf (user.password != null) user.password;
    initialPassword = mkIf (user.initialPassword != null) user.initialPassword;
    extraGroups = [
      "networkmanager"
      "network"
      "video"
      "sys"
      "audio"
      "optical"
      "scanner"
      "lp"
      (mkIf (if builtins.hasAttr "isSudoUser" user then user.isSudoUser else false) "wheel")
    ];

    uid = user.uid;
    openssh.authorizedKeys.keys = mkIf (user.authorizedKeys != null) user.authorizedKeys;
  };

  mkUserConfig = name: user: {
    # Home-Manager Config
    home = {
      username = name;
      homeDirectory = "/home/${name}";
      stateVersion = config.system.stateVersion;
    };
    programs.home-manager.enable = true;

    # Git Config
    programs.git = mkIf (if builtins.hasAttr "git" user then true else false) {
      enable = true;
      userName = user.git.userName;
      userEmail = user.git.userEmail;
      extraConfig = {
        safe.directory = "/etc/nixos";
        pager.branch = false;
      };
    };

    # XDG Config
    xdg.userDirs = mkIf (if builtins.hasAttr "isGuiUser" user then user.isGuiUser else false) {
      enable = true;
      createDirectories = true;
      extraConfig = {
        XDG_GAMES_DIR = "${config.home-manager.users.${name}.home.homeDirectory}/Games";
        XDG_GITHUB_DIR = "${config.home-manager.users.${name}.home.homeDirectory}/GitHub";
      };
    };

    # Import user specific modues if needed
  };
in
{
  options.boerg= {
    users = mkOption {
      default = {};
      type = attrsOf (submodule (
        { name, config, options, ... }:
        {
          options = {
            isGuiUser = mkOption {
              type = bool;
              default = false;
            };
            isSudoUser = mkOption {
              type = bool;
              default = false;
            };
            isKvmUser = mkOption {
              type = bool;
              default = false;
            };
            isDockerUser = mkOption {
              type = bool;
              default = false;
            };
            shell = mkOption {
              type = nullOr (shellPackage);
              default = null;
            };
            authorizedKeys = mkOption {
              type = nullOr (listOf singleLineStr);
              default = null;
            };
            uid = mkOption {
              type = nullOr (int);
              default = null;
            };
            password = mkOption {
              type = nullOr (str);
              default = null;
            };
            initialPassword = mkOption {
              type = nullOr (str);
              default = null;
            };
            extraGroups = mkOption {
              type = nullOr (listOf singleLineStr);
              default = null;
            };
            git = {
              userName = mkOption {
                type = str;
                default = name;
              };
              userEmail = mkOption {
                type = str;
                default = "unconfigured@boerg.co";
              };
            };
          };
        }
      ));
    };
  };

  config = mkIf (if cfg != {} then true else false) {
    # Create user
    users.users = mkMerge [ (mapAttrs mkUser cfg) { root.hashedPassword = "!"; } ];

    # Configure user
    home-manager.users = mapAttrs mkUserConfig cfg;
    home-manager.extraSpecialArgs = {
      systemConfig = config;
    };
  };
}
