{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  fastfetchConfigPath = "${config.home.homeDirectory}/src/nix-config/modules/home/cli/fastfetch/config.jsonc";
in {
  options = {
    aidan.home.cli.fastfetch.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables fastfetch home-manager module";
    };
  };

  config = lib.mkIf config.aidan.home.cli.fastfetch.enable {
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
