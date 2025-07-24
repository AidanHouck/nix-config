{
  config,
  pkgs,
  lib,
  ...
}: {
  # https://nixos.wiki/wiki/Nvidia#Modifying_NixOS_Configuration
  # Enable OpenGL
  hardware.graphics.enable = true;

  # Xorg nvidia driver
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false; # May need enabled if sleep/suspend issues
    powerManagement.finegrained = false;
    open = true; # Only needed past Turing (RTX 20-Series) cards
    nvidiaSettings = true; # `nvidia-settings` menu
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  system.stateVersion = "24.11";
}
