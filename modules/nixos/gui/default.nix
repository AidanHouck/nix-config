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
    ./awesome.nix
    ./libratbag.nix
  ];
}
