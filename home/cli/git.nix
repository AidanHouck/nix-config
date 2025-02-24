{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.cli.git;
in {
  options = {
    aidan.cli.git.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables git/gh home-manager module";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Aidan Houck";
      userEmail = "AidanHouck@users.noreply.github.com";
      aliases = {
        undo = "reset HEAD~";
        last = "log -1 HEAD";
      };

      extraConfig = {
        help = {
          autocorrect = "prompt";
        };
        init = {
          defaultBranch = "main";
        };
      };
    };

    # GitHub CLI for credential helper
    programs.gh = {
      enable = true;
    };

    sops.secrets."gh-hosts.yml" = {
      path = "${config.home.homeDirectory}/.config/gh/hosts.yml";
    };
  };
}
