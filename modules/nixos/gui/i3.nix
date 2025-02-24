{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.i3;
in {
  options = {
    aidan.gui.i3.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables x+i3 window manager";
    };
  };

  config = mkIf cfg.enable {
    environment.pathsToLink = ["/libexec"];

    services.displayManager.defaultSession = "none+i3";
    services.xserver = {
      enable = true;

      desktopManager = {
        xterm.enable = false;
      };

      displayManager = {
        lightdm.enable = false;
        gdm.enable = true;
      };

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          xorg.xinit # startx
          rofi # application launcher
          i3lock # default screen locker
          i3blocks # stauts bar
        ];
      };

      # X11 keymap
      xkb.layout = "us";
      xkb.variant = "";
    };
  };
}
