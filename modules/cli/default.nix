{pkgs, lib, config, ... }:
{
  imports = [
    ./git.nix
  ];

  options = {
    cli.disable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enable all cli modules";
    };
  };

  config = lib.mkIf (config.cli.enable != true) {
    cli.git.enable = lib.mkDefault false;
  };
}
