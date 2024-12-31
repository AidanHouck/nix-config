{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./wlan.nix
  ];
}
