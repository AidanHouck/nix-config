{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    gui.xfce.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables xfce desktop environment";
    };
  };

  config = lib.mkIf config.gui.xfce.enable {
    services.displayManager.defaultSession = "xfce";
    services.xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };
    };
  };
}
