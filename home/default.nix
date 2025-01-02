{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./cli
    #./gui
    ./shell
  ];
}
