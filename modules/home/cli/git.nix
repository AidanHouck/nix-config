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

    aidan.cli.git.displayName = mkOption {
      default = "Aidan Houck";
      type = types.str;
      description = "Display name to use for commits";
    };

    aidan.cli.git.email = mkOption {
      default = "${config.aidan.vars.githubAccount}@users.noreply.github.com";
      type = types.str;
      description = "Email to use for git commits";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = cfg.displayName;
          email = cfg.email;
        };

        aliases = {
          undo = "reset HEAD~";
          last = "log -1 HEAD";
        };

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
      settings.aliases = {
        i = "issue";
        is = "issue";
        iss = "issue";
      };
    };

    sops.secrets."gh-hosts.yml" = {
      path = "${config.home.homeDirectory}/.config/gh/hosts.yml";
    };
  };
}
