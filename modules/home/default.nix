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
        home.packages = with pkgs; [
          discord
          bitwarden-desktop

          libreoffice-qt-still
          hunspell # spellcheck
          hunspellDicts.en_US

          tauon # music player
          mpv # media player
          koreader # ebook reader
          pinta # MS paint replacement

          prusa-slicer # gcode slicer
        ];

        aidan.gui.firefox.enable = mkDefault true;
        aidan.gui.alacritty.enable = mkDefault true;
      })
      (mkIf cfg.home {
        home.packages = with pkgs; [
          ffmpeg
          wine
          weechat # irc client
          lrcget # mass-download lyrics for music
        ];
      })
    ];
}
