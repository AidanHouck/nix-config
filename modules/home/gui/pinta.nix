{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.pinta;
in {
  options = {
    aidan.gui.pinta.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables the pinta app";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pinta
    ];
  };
}
