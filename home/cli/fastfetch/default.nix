{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.cli.fastfetch;
  fastfetchConfigPath = "${config.home.homeDirectory}/src/nix-config/modules/home/cli/fastfetch/config.jsonc";
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

    home.file = {
      ".config/fastfetch/config.jsonc" = {
        source = config.lib.file.mkOutOfStoreSymlink fastfetchConfigPath;
      };
    };
  };
}
