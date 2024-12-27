{ config, pkgs, lib, inputs, ... }:

let
  hostname = "nixos-wsl-home";
in {
  # Imports
  imports = [
    ../common.nix
  ];

  config = {
    variables.hostname = hostname;

    # Host specific packages
    environment.systemPackages = with pkgs; [
      shellcheck
    ];

    # WSL specific config
    wsl.enable = true;
    wsl.wslConf.network.hostname = hostname;
    wsl.defaultUser = config.system.users.username;

    system.stateVersion = "24.05";
  };
}
