{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./firefox.nix
    ./discord.nix
  ];
}
