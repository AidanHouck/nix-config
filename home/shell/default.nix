{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./bash
    ./zsh
  ];
}
