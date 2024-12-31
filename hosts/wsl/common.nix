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
    wsl.defaultUser = config.aidan.modules.system.users.username;

    system.stateVersion = "24.05";
  };
}
