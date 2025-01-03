{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  hostname = "router";
in {
  # Imports
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  config = {
    aidan.modules.network.hostname.enable = true;
    aidan.vars.hostname = hostname;

    # Host specific packages
    environment.systemPackages = with pkgs; [
      # TODO
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    system.stateVersion = "24.11";
  };
}
