{ inputs, lib, config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    userName = "Aidan Houck";
    userEmail = "AidanHouck@users.noreply.github.com";

  };

  home.stateVersion = "24.11";
}
