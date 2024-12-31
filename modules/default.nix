{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./system
    ./network
    ./cli
    #./gui
  ];
}
