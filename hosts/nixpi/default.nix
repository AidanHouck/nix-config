{ config, pkgs, lib, ... }:

let
  user = "houck";
  password = "FooBar";
  SSID = "FooBar";
  SSIDpassword = "FooBar";
  interface = "wlan0";
  hostname = "nixpi";
in {
  # Imports
  imports = [
    ../common.nix
    ./hardware-configuration.nix
  ];

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


  # Host system configuration
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = lib.mkForce "/dev/disk/by-label/NIXOS_SD"; #Override hardware-configuration.nix
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  networking = {
    hostName = hostname;
    wireless = {
      enable = true;
      networks."${SSID}".psk = SSIDpassword;
      interfaces = [ interface ];
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "24.05";
}
