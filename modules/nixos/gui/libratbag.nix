{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.libratbag;
in {
  options = {
    aidan.gui.libratbag.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables the libratbagd for logitech remapping && piper frontend gui";
    };
  };

  config = mkIf cfg.enable {
    # Use the following to reprogram G502 for R-Ctrl.
    # This is non-declarative but it persists in the mouse firmware so oh well
    #   ratbagctl list
    #   ratbagctl thundering-gerbil info
    #   ratbagctl thundering-gerbil button 5 action set macro +KEY_RIGHTCTRL KEY_F20 -KEY_RIGHTCTRL
    environment.systemPackages = with pkgs; [
      libratbag # Backend
      piper # GUI
    ];

    services.ratbagd.enable = true;
  };
}
