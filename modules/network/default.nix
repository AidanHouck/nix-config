{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./wlan.nix
    ./hostname.nix
  ];
}
