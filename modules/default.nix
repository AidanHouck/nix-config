{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./system
    ./cli
    #./gui
  ];
}
