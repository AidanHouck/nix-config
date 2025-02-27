{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.xfce;
in {
  options = {
    aidan.gui.xfce.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables xfce desktop environment";
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.defaultSession = "xfce";
    services.xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };
    };

    environment.systemPackages = with pkgs.xfce; [
      xfce4-clipman-plugin
    ];

    environment.xfce.excludePackages = with pkgs.xfce; [
      xfce4-notifyd
    ];
  };
}
