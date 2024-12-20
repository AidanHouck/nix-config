{ config, pkgs, ... }:

{
  home.username = "houck";
  home.homeDirectory = "/home/houck";

  home.packages = with pkgs; [
    fzf
  ];

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
