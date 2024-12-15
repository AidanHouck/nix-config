{ pkgs, lib, config, ... }:
{
  options = {
    system.sudo.enable = lib.mkEnableOption {
      default = true;
      description = "enables passwordless sudo";
    };
  };

  config = lib.mkIf config.system.sudo.enable {
    security.sudo.extraRules = [
      {
        groups = [ "wheel" ];
        commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
      }
    ];
  };
}
