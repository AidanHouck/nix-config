{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Imports
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./../modules/nixos
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/houck/.config/sops/age/keys.txt";

  # Enable Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Software important for maintaining the system
  environment.systemPackages = with pkgs; [
    git # Must init git first for Flakes dependency cloning
    sops # Nix secret management
    gh # GitHub CLI
    home-manager
  ];

  boot.loader.systemd-boot.configurationLimit = 10;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;
}
