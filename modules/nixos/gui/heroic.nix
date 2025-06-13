{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.heroic;
in {
  options = {
    aidan.gui.heroic.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables heroic game launcher (epic games)";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      heroic
    ];
  };
}
