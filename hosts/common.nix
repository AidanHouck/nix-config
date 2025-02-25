{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Imports
  imports = [
    inputs.sops-nix.nixosModules.sops
    ./../modules/nixos
  ];

  config = {
    networking.hostName = config.aidan.vars.hostname;

    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";

    environment.variables.EDITOR = "vim";
    environment.variables.GIT_EDITOR = "vim -c'norm! ggA'";

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Software important for maintaining the system
    environment.systemPackages = with pkgs; [
      git # Must init git first for Flakes dependency cloning
      sops # Nix secret management
      gh # GitHub CLI
      home-manager
      just
      vim
    ];

    sops.defaultSopsFile = ../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/houck/.config/sops/age/keys.txt";

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    # https://discourse.nixos.org/t/difference-between-nix-settings-auto-optimise-store-and-nix-optimise-automatic/25350
    nix.settings.auto-optimise-store = true;
    nix.optimise.automatic = true;

    boot.loader.systemd-boot.configurationLimit = 10;
  };
}
