{ pkgs, lib, config, ... }:
{
  options = {
    sudo.enable = lib.mkEnableOption "enables sudo";
  };

  config = lib.mkIf config.sudo.enable {
    security.sudo.extraRules = [
      {
        groups = [ "wheel" ];
        commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
      }
    ];
  };
}
