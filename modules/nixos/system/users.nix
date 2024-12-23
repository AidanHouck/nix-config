{ pkgs, lib, config, ... }:
{
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
        extraGroups = [ "wheel" ]; # wheel for sudo
      };
    };
  };
}
