{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./firefox.nix
    ./discord.nix
    ./bitwarden.nix
    ./alacritty.nix
  ];
}
