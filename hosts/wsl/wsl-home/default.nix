{ config, pkgs, lib, inputs, ... }:

let
  hostname = "wsl-home";
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
      shellcheck
    ];

    system.stateVersion = "24.05";
  };
}
