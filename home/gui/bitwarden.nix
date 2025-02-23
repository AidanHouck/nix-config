{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    aidan.home.gui.bitwarden.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables the bitwarden password manager";
    };
  };

  config = lib.mkIf config.aidan.home.gui.bitwarden.enable {
    home.packages = with pkgs; [
      bitwarden-desktop
    ];
  };
}
