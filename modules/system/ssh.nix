{ pkgs, lib, config, ... }:
{
  options = {
    system.ssh.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables inbound ssh";
    };
  };

  config = lib.mkIf config.system.ssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
