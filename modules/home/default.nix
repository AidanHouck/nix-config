{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption mkDefault mkMerge types;
  cfg = config.aidan.profile;
in {
  imports = [
    ./../vars.nix # System-wide variables

    ./cli
    ./gui
    ./shell
  ];

  options = {
    aidan.profile.gui = mkOption {
      default = false;
      type = types.bool;
      description = "enables all gui packages";
    };
  };

  config =
    mkMerge
    [
      (mkIf cfg.gui {
        aidan.gui.firefox.enable = mkDefault true;
        aidan.gui.discord.enable = mkDefault true;
        aidan.gui.bitwarden.enable = mkDefault true;
        #aidan.gui.alacritty.enable = mkDefault true;
      })
    ];
}
