{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.awesome;
in {
  options = {
    aidan.gui.awesome.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables x+awesomewm";
    };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;

      displayManager = {
        defaultSession = "none+awesome";
        sddm.enable = true;
      };

      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          #foo
        ];
      };

      # X11 keymap
      xkb.layout = "us";
      xkb.variant = "";
    };
  };
}
