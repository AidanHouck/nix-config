{ config, pkgs, lib, inputs, ... }:

{
  # Imports
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./../modules
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/houck/.config/sops/age/keys.txt";
  sops.secrets."wireless.env" = { };
  sops.secrets."github_token" = { };

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Common software
  environment.systemPackages = with pkgs; [
    git # Must init git first for Flakes dependency cloning
    gh # GitHub CLI
    vim
    wget
  ];
  environment.variables.EDITOR = "vim";
}
