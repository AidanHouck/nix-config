{pkgs, lib, config, ... }:
{
  imports = [
    ./ssh.nix
    ./sudo.nix
    ./wlan.nix
  ];

  options = {
    system.enable = lib.mkOption {
      default = true;
      description = "enables all default system modules";
    };
  };

  config = lib.mkIf (config.system.enable != true) {
    system.ssh.enable = lib.mkDefault false;
    system.sudo.enable = lib.mkDefault false;
    system.wlan.enable = lib.mkDefault false;
  };
}
