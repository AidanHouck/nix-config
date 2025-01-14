{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./.
  ];

  home.username = "houck";
  home.homeDirectory = "/home/houck";

  news.display = "silent";

  sops.defaultSopsFile = ./../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/houck/.config/sops/age/keys.txt";

  # Packages not defined explicitly in subdir modules
  home.packages = with pkgs; [
    # Basic Utils
    bat
    tree
    bc
    screen
    dos2unix
    file
    #binutils # strings
    #pngcheck

    # Larger Utils
    #pandoc
    #ffmpeg

    # Quality of Life
    fzf
    shellcheck

    # Networking Utils
    dig
    traceroute
    tcpdump
    mtr
    nmap
    whois
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
