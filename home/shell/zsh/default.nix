{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.shell.zsh;
  zshrcPath = "${config.home.homeDirectory}/src/nix-config/home/shell/zsh/.zshrc";
in {
  options = {
    aidan.shell.zsh.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables zsh home-manager module";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
    };

    home.file = {
      ".zshrc" = {
        source = config.lib.file.mkOutOfStoreSymlink zshrcPath;
      };
    };
  };
}
