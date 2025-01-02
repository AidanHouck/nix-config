{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./../../../home/common.nix
  ];

  # Enable ZSH
  aidan.home.shell.zsh.enable = true;
  aidan.home.shell.bash.enable = false;

  # Packages for this host only
  home.packages = with pkgs; [
    # TODO
  ];

  home.stateVersion = "24.11";
}
