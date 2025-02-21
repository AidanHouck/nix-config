{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    gui.i3.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables x+i3 window manager";
    };
  };

  config = lib.mkIf config.gui.i3.enable {
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
