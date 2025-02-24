{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.system.ssh;
in {
  options = {
    aidan.system.ssh.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables inbound ssh";
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
}
