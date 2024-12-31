{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    aidan.modules.system.sudo.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables passwordless sudo";
    };
  };

  config = lib.mkIf config.aidan.modules.system.sudo.enable {
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
