{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  hostname = "nixpi";
in {
  # Imports
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  config = {
    aidan.vars.hostname = hostname;

    system.wlan.enable = true;
    aidan.vars.interface = "wlan0";

    # Host specific packages
    environment.systemPackages = with pkgs; [
      # TODO
    ];

    # Pi kernel config
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
      initrd.availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
      loader = {
        grub.enable = false;
        generic-extlinux-compatible.enable = true;
      };
    };

    # Pi filesystem config
    fileSystems = {
      "/" = {
        device = lib.mkForce "/dev/disk/by-label/NIXOS_SD"; #Override hardware-configuration.nix
        fsType = "ext4";
        options = ["noatime"];
      };
    };

    hardware.enableRedistributableFirmware = true;
    system.stateVersion = "24.05";
  };
}
