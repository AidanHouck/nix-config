{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./git.nix
    ./vim
    ./bash
    ./fastfetch
  ];

  options = {
    home.cli.enable = lib.mkOption {
      default = true;
      description = "enables all default home-manager cli modules";
    };
  };

  config = lib.mkIf (config.home.cli.enable != true) {
    home.cli.git.enable = lib.mkDefault true;
  };
}
