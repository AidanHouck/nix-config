{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./vim
    ./fastfetch
    ./tmux
    ./git.nix
    ./ranger.nix
  ];
}
