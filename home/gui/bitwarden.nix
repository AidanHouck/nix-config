{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.bitwarden;
in {
  options = {
    aidan.gui.bitwarden.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables the bitwarden password manager";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}
