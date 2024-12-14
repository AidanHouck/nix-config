{pkgs, lib, config, ... }:
{
  imports = [
    ./ssh.nix
    ./sudo.nix
    ./wlan.nix
  ];

  options = {
    variables = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  config = {
    ssh.enable = lib.mkDefault true;
    sudo.enable = lib.mkDefault true;
    wlan.enable = lib.mkDefault false;
  };
}
