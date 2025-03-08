{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./vim
    ./fastfetch
    ./git.nix
  ];
}
