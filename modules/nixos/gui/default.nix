{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./i3.nix
    ./xfce.nix
    ./steam.nix
  ];
}
