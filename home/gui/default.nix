{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./firefox.nix
  ];
}
