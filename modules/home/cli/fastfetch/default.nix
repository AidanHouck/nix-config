{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.cli.fastfetch;
in {
  options = {
    aidan.cli.fastfetch.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables fastfetch home-manager module";
    };
  };

  config = mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
    };

    home.file = with config.lib.file; {
      ".config/fastfetch/config.jsonc".source = mkOutOfStoreSymlink ./config.jsonc;
    };
  };
}
