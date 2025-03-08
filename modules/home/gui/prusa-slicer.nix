{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.prusa-slicer;
in {
  options = {
    aidan.gui.prusa-slicer.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables the prusa-slicer app";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      prusa-slicer
    ];
  };
}
