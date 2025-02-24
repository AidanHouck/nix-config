{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./git.nix
    ./bitwarden-cli.nix
    ./kubectl.nix
  ];
}
