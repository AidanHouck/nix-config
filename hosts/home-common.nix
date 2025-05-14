{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./../modules/home
  ];

  home.username = "houck";
  home.homeDirectory = "/home/houck";

  xdg.enable = true;
  home.preferXdgDirectories = true;

  news.display = "silent";

  # Allow unfree packages
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  sops.defaultSopsFile = ./../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

  # Packages not defined explicitly in subdir modules
  home.packages = with pkgs; [
    # Basic Utils
    bat
    ripgrep
    tldr
    tree
    bc
    screen
    dos2unix
    file
    unzip
    #binutils # strings
    #pngcheck

    # Larger Utils
    #pandoc

    # Quality of Life
    fzf
    shellcheck

    # Networking Utils
    inetutils # telnet
    wget
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
