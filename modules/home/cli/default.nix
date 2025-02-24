{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./git.nix
    ./vim
    ./fastfetch
  ];
}
