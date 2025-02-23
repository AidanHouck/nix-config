{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    aidan.home.gui.discord.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables the discord app";
    };
  };

  config = lib.mkIf config.aidan.home.gui.discord.enable {
    home.packages = with pkgs; [
      discord
    ];
  };
}
