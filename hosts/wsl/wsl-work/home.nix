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
    # Packages for this host only
    home.packages = with pkgs; [
      # TODO
    ];

    home.stateVersion = "24.11";
  };
}
