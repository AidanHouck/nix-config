{ config, pkgs, lib, inputs, ... }:

let
  user = "houck";
  password = "FooBar";
  interface = "wlan0";
  hostname = "nixpi";
in {
  # Imports
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

  config = {
    wlan.enable = true;

    variables.hostname = hostname;
    variables.interface = interface;

    # Host specific packages
    environment.systemPackages = with pkgs; [
      shellcheck
    ];

    users = {
      mutableUsers = false;
      users."${user}" = {
        isNormalUser = true;
        password = password;
        extraGroups = [ "wheel" ];
      };
    };

    # Pi kernel config
    boot = {
      kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
      initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
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
        options = [ "noatime" ];
      };
    };

    hardware.enableRedistributableFirmware = true;
    system.stateVersion = "24.05";
  };
}
