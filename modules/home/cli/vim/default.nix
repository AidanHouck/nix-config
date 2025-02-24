{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.cli.vim;
in {
  options = {
    aidan.cli.vim.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables vim home-manager module";
    };
  };

  config = mkIf cfg.enable {
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
        source = config.lib.file.mkOutOfStoreSymlink ./.vimrc;
      };
      ".vim/vim_bash" = {
        source = config.lib.file.mkOutOfStoreSymlink ./vim_bash;
      };
    };
  };
}
