{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.cli.tmux;
in {
  options = {
    aidan.cli.tmux.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables tmux session manager module";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      terminal = "screen-256color";
      extraConfig = "source-file ~/.config/tmux/tmux-nix.conf";
    };

    home.file = with config.lib.file; {
      ".config/tmux/tmux-nix.conf".source = mkOutOfStoreSymlink ./tmux-nix.conf;
      ".config/tmux/tmux-help".source = mkOutOfStoreSymlink ./tmux-help.sh;
    };
  };
}
