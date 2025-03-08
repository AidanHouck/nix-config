{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./alacritty
    ./firefox.nix
  ];
}
