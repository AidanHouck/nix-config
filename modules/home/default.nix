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

    aidan.profile.home = mkOption {
      default = false;
      type = types.bool;
      description = "enables all packages that are only used at home";
    };
  };

  config =
    mkMerge
    [
      (mkIf cfg.gui {
        aidan.gui.firefox.enable = mkDefault true;
        aidan.gui.discord.enable = mkDefault true;
        aidan.gui.bitwarden.enable = mkDefault true;
        aidan.gui.alacritty.enable = mkDefault true;
        aidan.gui.libreoffice.enable = mkDefault true;
        aidan.gui.pinta.enable = mkDefault true;
      })
      (mkIf cfg.home {
        aidan.cli.ffmpeg.enable = mkDefault true;
        aidan.cli.weechat.enable = mkDefault true;
      })
    ];
}
