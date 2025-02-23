{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  hostname = "desktop";
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

    gui.xfce.enable = true;
    gui.steam.enable = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    system.stateVersion = "24.11";
  };
}
