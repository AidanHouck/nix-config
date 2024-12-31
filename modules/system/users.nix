{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    system.users.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables user creation";
    };

    system.users.username = lib.mkOption {
      default = "houck";
      type = lib.types.str;
      description = "username to create";
    };
  };

  config = lib.mkIf config.system.users.enable {
    sops.secrets."${config.system.users.username}_pass_hash".neededForUsers = true;

    users = {
      mutableUsers = false;
      users.${config.system.users.username} = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets."${config.system.users.username}_pass_hash".path;
        extraGroups = ["wheel"]; # wheel for sudo

        # Fetch allowed public keys from GitHub
        # Ref: https://discourse.nixos.org/t/fetching-ssh-public-keys/12076/3
        openssh.authorizedKeys.keys = let
          authorizedKeys = pkgs.fetchurl {
            url = "https://github.com/AidanHouck.keys";
            sha256 = "sha256-7OJn9Tjjl8XuK2tR919ZVFhJ07FyFDDpcmx8w0meU0c=";
          };
        in
          pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
      };
    };
  };
}
