{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    aidan.modules.system.users.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables user creation";
    };

    aidan.modules.system.users.username = lib.mkOption {
      default = "houck";
      type = lib.types.str;
      description = "username to create";
    };
  };

  config = lib.mkIf config.aidan.modules.system.users.enable {
    sops.secrets."${config.aidan.modules.system.users.username}_pass_hash".neededForUsers = true;

    users = {
      mutableUsers = false;
      users.${config.aidan.modules.system.users.username} = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets."${config.aidan.modules.system.users.username}_pass_hash".path;
        extraGroups = ["wheel"]; # wheel for sudo

        # Fetch allowed public keys from GitHub
        # Ref: https://discourse.nixos.org/t/fetching-ssh-public-keys/12076/3
        openssh.authorizedKeys.keys = let
          authorizedKeys = pkgs.fetchurl {
            url = "https://github.com/AidanHouck.keys";
            sha256 = "sha256-CqWFoY5gnl1csq9p96hDceZlbD2ycWhX8DdpWrlwPQY=";
          };
        in
          pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
      };
    };
  };
}
