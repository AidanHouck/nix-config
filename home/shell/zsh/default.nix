{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  zshrcPath = "${config.home.homeDirectory}/src/nix-config/home/shell/zsh/.zshrc";
in {
  options = {
    aidan.home.shell.zsh.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables zsh home-manager module";
    };
  };

  config = lib.mkIf config.aidan.home.shell.zsh.enable {
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
