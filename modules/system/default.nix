{pkgs, lib, config, ... }:
{
  imports = [
    ./ssh.nix
    ./sudo.nix
    ./wlan.nix
  ];

  options = {
    system.disable = lib.mkEnableOption {
      default = false;
      description = "disables all system modules";
    };
  };

  config = lib.mkIf config.system.disable {
    system.ssh.enable = lib.mkDefault false;
    system.sudo.enable = lib.mkDefault false;
    system.wlan.enable = lib.mkDefault false;
  };
}
