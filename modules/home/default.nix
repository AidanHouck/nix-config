{ inputs, lib, config, pkgs, ... }:

{
  imports = [
    ./git.nix
  ];

  home.username = "houck";
  home.homeDirectory = "/home/houck";

  home.packages = with pkgs; [
    fzf
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
