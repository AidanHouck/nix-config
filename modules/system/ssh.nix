{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    aidan.modules.system.ssh.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables inbound ssh";
    };
  };

  config = lib.mkIf config.aidan.modules.system.ssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
