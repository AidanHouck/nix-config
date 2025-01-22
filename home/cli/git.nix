{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    aidan.home.cli.git.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables git/gh home-manager module";
    };
  };

  config = lib.mkIf config.aidan.home.cli.git.enable {
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
