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

  # Host specific package
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

  # Setup wireless using SSID/PSK from SOPS file
  networking = {
    hostName = hostname;
    wireless = {
      enable = true;
      environmentFile = config.sops.secrets."wireless.env".path;
      networks = {
        "@home_uuid@" = {
          psk = "@home_psk@";
        };
      };
      interfaces = [ interface ];
    };
  };

  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "24.05";
}
