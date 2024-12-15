{pkgs, lib, config, ... }:
{
  imports = [
    ./system
    ./cli
    #./gui
  ];

  options = {
    variables = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };
}
