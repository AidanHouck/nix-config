{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./cli
  ];

  home.username = "houck";
  home.homeDirectory = "/home/houck";

  sops.defaultSopsFile = ./../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/houck/.config/sops/age/keys.txt";

  # Packages not defined explicitly in subdir modules
  home.packages = with pkgs; [
    fzf
    tree
    wget
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
