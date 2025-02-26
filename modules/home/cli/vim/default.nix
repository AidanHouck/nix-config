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
        source ~/.config/vim/.vimrc " Nix will only use its' auto-generated .vimrc by default.
      '';
      #plugins = with pkgs.vimPlugins; [
      #  vim-just
      #  vim-autoformat
      #];
    };

    home.file = with config.lib.file; {
      ".config/vim/.vimrc".source = mkOutOfStoreSymlink ./.vimrc;
      ".config/vim/vim_bash".source = mkOutOfStoreSymlink ./vim_bash;
    };
  };
}
