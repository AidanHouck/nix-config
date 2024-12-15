{ pkgs, lib, config, ... }:
{
  options = {
    system.ssh.enable = lib.mkEnableOption {
      default = true;
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
