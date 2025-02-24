{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.discord;
in {
  options = {
    aidan.gui.discord.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables the discord app";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}
