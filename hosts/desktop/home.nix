{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./../home-common.nix
  ];

  # Packages for this host only
  home.packages = with pkgs; [
    # TODO
  ];

  aidan.home.gui.firefox.enable = true;
  aidan.home.gui.discord.enable = true;
  aidan.home.gui.bitwarden.enable = true;

  home.stateVersion = "24.11";
}
