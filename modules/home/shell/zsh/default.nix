{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.shell.zsh;
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

    home.file = with config.lib.file; {
      # TODO: Move to ~/.config
      ".zshrc".source = mkOutOfStoreSymlink ./.zhsrc;
    };
  };
}
