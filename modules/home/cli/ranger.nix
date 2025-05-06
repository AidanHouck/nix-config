{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.cli.ranger;
in {
  options = {
    aidan.cli.ranger.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables ranger file manager";
    };
  };

  config = mkIf cfg.enable {
    programs.ranger = {
      enable = true;
      mappings = {
        E = "edit";
        yc = "shell -p cat %s | /mnt/c/Windows/system32/clip.exe";
        yp = "yank path";
        yd = "yank dir";
        yn = "yank name";
      };
    };
  };
}
