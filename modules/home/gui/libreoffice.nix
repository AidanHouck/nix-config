{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.libreoffice;
in {
  options = {
    aidan.gui.libreoffice.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables the libreoffice suite of apps";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      libreoffice-qt-still
      hunspell # Spellcheck
      hunspellDicts.en_US
    ];
  };
}
