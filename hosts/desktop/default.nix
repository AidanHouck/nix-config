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
    ./drivers.nix
  ];

  config = {
    aidan.vars.hostname = hostname;

    aidan.profile.home = true;
    aidan.profile.gui = true;

    services.libinput.mouse.middleEmulation = false;

    # Host specific packages
    environment.systemPackages = with pkgs; [
      # TODO
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    system.stateVersion = "24.11";
  };
}
