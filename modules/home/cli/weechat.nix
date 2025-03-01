{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.cli.weechat;
in {
  options = {
    aidan.cli.weechat.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables weechat";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      weechat
    ];
  };
}
