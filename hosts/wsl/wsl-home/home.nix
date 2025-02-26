{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./../../home-common.nix
  ];

  config = {
    aidan.profile.home = true;

    # Packages for this host only
    home.packages = with pkgs; [
      # TODO
    ];

    home.stateVersion = "24.11";
  };
}
