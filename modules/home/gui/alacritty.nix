{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.alacritty;
in {
  options = {
    aidan.gui.alacritty.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables the alacritty terminal emulator";
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {};
    };

    # TODO: Append bash autocompletion: https://github.com/alacritty/alacritty/blob/master/INSTALL.md#bash
  };
}
