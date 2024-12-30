{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  vimrcPath = "${config.home.homeDirectory}/src/nix-config/modules/home/cli/.vimrc";
in {
  options = {
    home.cli.vim.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables vim home-manager module";
    };
  };

  config = lib.mkIf config.home.cli.vim.enable {
    programs.vim = {
      enable = true;
      plugins = [pkgs.vimPlugins.vim-just];
    };

    home.file = {
      ".vimrc" = {
        source = config.lib.file.mkOutOfStoreSymlink vimrcPath;
      };
    };
  };
}
