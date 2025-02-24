{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.shell.bash;
  bashrcPath = "${config.home.homeDirectory}/src/nix-config/modules/home/shell/bash/.bashrc";
  bash_profilePath = "${config.home.homeDirectory}/src/nix-config/modules/home/shell/bash/.bash_profile";
  bash_aliasesPath = "${config.home.homeDirectory}/src/nix-config/modules/home/shell/bash/.bash_aliases";
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
        source = config.lib.file.mkOutOfStoreSymlink bashrcPath;
      };
      ".bash_profile" = {
        source = config.lib.file.mkOutOfStoreSymlink bash_profilePath;
      };
      ".bash_aliases" = {
        source = config.lib.file.mkOutOfStoreSymlink bash_aliasesPath;
      };
    };
  };
}
