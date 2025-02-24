{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Imports
  imports = [
    ../common.nix
  ];

  config = {
    # WSL config
    wsl.enable = true;
    wsl.defaultUser = config.aidan.vars.username;
    wsl.wslConf.network.hostname = config.aidan.vars.hostname;

    system.stateVersion = "24.05";
  };
}
