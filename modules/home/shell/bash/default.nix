{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  bashrcPath = "${config.home.homeDirectory}/src/nix-config/modules/home/shell/bash/.bashrc";
  bash_profilePath = "${config.home.homeDirectory}/src/nix-config/modules/home/shell/bash/.bash_profile";
  bash_aliasesPath = "${config.home.homeDirectory}/src/nix-config/modules/home/shell/bash/.bash_aliases";
in {
  options = {
    home.shell.bash.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables bash home-manager module";
    };
  };

  config = lib.mkIf config.home.shell.bash.enable {
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
