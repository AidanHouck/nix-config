{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.shell.bash;
in {
  options = {
    aidan.shell.bash.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables bash home-manager module";
    };
  };

  config = mkIf cfg.enable {
    #programs.bash = {
    #  enable = true;
    #};

    home.file = {
      ".bashrc" = {
        source = config.lib.file.mkOutOfStoreSymlink ./.bashrc;
      };
      ".bash_profile" = {
        source = config.lib.file.mkOutOfStoreSymlink ./.bash_profile;
      };
      ".bash_aliases" = {
        source = config.lib.file.mkOutOfStoreSymlink ./.bash_aliases;
      };
    };
  };
}
