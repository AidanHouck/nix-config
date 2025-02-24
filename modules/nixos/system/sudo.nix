{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.system.sudo;
in {
  options = {
    aidan.system.sudo.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables passwordless sudo";
    };
  };

  config = mkIf cfg.enable {
    security.sudo.extraRules = [
      {
        groups = ["wheel"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];
  };
}
