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
    ./../modules
  ];

  # All system-wide config defined under `aidan.vars.x` scope
  options = {
    aidan.vars = lib.mkOption {
      type = lib.types.attrs;
      default = {};
    };
  };

  config = {
    sops.defaultSopsFile = ../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/houck/.config/sops/age/keys.txt";

    # Enable Flakes
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
    environment.variables.EDITOR = "vim";

    boot.loader.systemd-boot.configurationLimit = 10;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };

    # https://discourse.nixos.org/t/difference-between-nix-settings-auto-optimise-store-and-nix-optimise-automatic/25350
    nix.settings.auto-optimise-store = true;
    nix.optimise.automatic = true;
  };
}
