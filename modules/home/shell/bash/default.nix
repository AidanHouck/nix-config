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
    # This causes issues with the module trying to setup it's own .bashrc, .bash_profile, etc
    #programs.bash = {
    #  enable = true;
    #};

    home.file = with config.lib.file; {
      # TODO: Move this to .config/bash
      ".bashrc".source = mkOutOfStoreSymlink ./.bashrc;
      ".bash_profile".source = mkOutOfStoreSymlink ./.bash_profile;
      ".bash_aliases".source = mkOutOfStoreSymlink ./.bash_aliases;
    };
  };
}
