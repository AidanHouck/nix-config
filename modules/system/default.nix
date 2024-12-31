{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./ssh.nix
    ./sudo.nix
    ./wlan.nix
    ./users.nix
  ];
}
