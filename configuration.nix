{ config, pkgs, lib, ... }:

let
  user = "houck";
  password = "FooBar";
  SSID = "FooBar";
  SSIDpassword = "FooBar";
  interface = "wlan0";
  hostname = "nixpi";
in {

  # Nix Configuration
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Userspace Configuration
  environment.systemPackages = with pkgs; [
    git # Must init git first for Flakes dependency cloning
    vim
    wget
    shellcheck
  ];
  environment.variables.EDITOR = "vim";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  users = {
    mutableUsers = false;
    users."${user}" = {
      isNormalUser = true;
      password = password;
      extraGroups = [ "wheel" ];
    };
  };

  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];

  # System Configuration
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
