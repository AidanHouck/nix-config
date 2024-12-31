{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    home.cli.git.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables git/gh home-manager module";
    };
  };

  config = lib.mkIf config.home.cli.git.enable {
    programs.git = {
      enable = true;
      userName = "Aidan Houck";
      userEmail = "AidanHouck@users.noreply.github.com";
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
