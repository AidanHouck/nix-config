{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.cli.ffmpeg;
in {
  options = {
    aidan.cli.ffmpeg.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables ffmpeg";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ffmpeg
    ];
  };
}
