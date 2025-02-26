{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./alacritty

    ./firefox.nix
    ./discord.nix
    ./bitwarden.nix
  ];
}
