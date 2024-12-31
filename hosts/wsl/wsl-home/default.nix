{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  hostname = "wsl-home";
in {
  # Imports
  imports = [
    ../common.nix
  ];

  config = {
    aidan.vars.hostname = hostname;
    wsl.wslConf.network.hostname = hostname;

    # Host specific packages
    environment.systemPackages = with pkgs; [
      # TODO
    ];

    system.stateVersion = "24.05";
  };
}
