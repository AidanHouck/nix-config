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
    ./libreoffice.nix
    ./pinta.nix
    ./prusa-slicer.nix
  ];
}
