{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  vimrcPath = "${config.home.homeDirectory}/src/nix-config/home/cli/vim/.vimrc";
  vimBashPath = "${config.home.homeDirectory}/src/nix-config/home/cli/vim/vim_bash";
in {
  options = {
    aidan.home.cli.vim.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables vim home-manager module";
    };
  };

  config = lib.mkIf config.aidan.home.cli.vim.enable {
    programs.vim = {
      enable = true;
      extraConfig = ''
        source ~/.vimrc " Nix will only use its' auto-generated .vimrc by default.
      '';
      #plugins = with pkgs.vimPlugins; [
      #  vim-just
      #  vim-autoformat
      #];
    };

    home.file = {
      ".vimrc" = {
        source = config.lib.file.mkOutOfStoreSymlink vimrcPath;
      };
      ".vim/vim_bash" = {
        source = config.lib.file.mkOutOfStoreSymlink vimBashPath;
      };
    };
  };
}
