{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  hostname = "wsl-work";
in {
  # Imports
  imports = [
    ../common.nix
  ];

  config = {
    variables.hostname = hostname;
    wsl.wslConf.network.hostname = hostname;

    # Host specific packages
    environment.systemPackages = with pkgs; [
      # TODO
    ];

    system.stateVersion = "24.05";
  };
}
