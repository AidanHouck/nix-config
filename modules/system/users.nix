{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.system.users;
in {
  options = {
    aidan.system.users.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables user creation";
    };

    aidan.system.users.username = mkOption {
      default = config.aidan.vars.username;
      type = types.str;
      description = "username to create";
    };
  };

  config = mkIf cfg.enable {
    sops.secrets."${cfg.username}_pass_hash".neededForUsers = true;

    users = {
      mutableUsers = false;
      users.${cfg.username} = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets."${cfg.username}_pass_hash".path;
        extraGroups = ["wheel"]; # wheel for sudo

        # Fetch allowed public keys from GitHub
        # Ref: https://discourse.nixos.org/t/fetching-ssh-public-keys/12076/3
        openssh.authorizedKeys.keys = let
          authorizedKeys = pkgs.fetchurl {
            url = "https://github.com/AidanHouck.keys";
            sha256 = "sha256-z7Tuzn5jgYU9pEKZKhfkBqLj2ImY3JyLrH6uKdvicLg=";
          };
        in
          pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
      };
    };
  };
}
