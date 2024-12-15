{pkgs, lib, config, ... }:
{
  imports = [
    ./git.nix
  ];

  options = {
    cli.disable = lib.mkEnableOption {
      default = false;
      description = "disables all cli modules";
    };
  };

  config = lib.mkIf config.cli.disable {
    cli.git.enable = lib.mkDefault false;
  };
}
