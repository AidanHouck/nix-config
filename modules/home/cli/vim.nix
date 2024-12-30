{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
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
    };

    home.file = {
      ".vimrc" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/nix-config/modules/home/cli/.vimrc";
      };
    };
  };
}
