{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption mkMerge mkDefault types;
  cfg = config.aidan.profile;
in {
  imports = [
    ./../vars.nix # System-wide variables

    ./system
    ./network
    ./cli
    ./gui
  ];

  options = {
    aidan.profile.work = mkOption {
      default = false;
      type = types.bool;
      description = "enables work-related packages";
    };

    aidan.profile.home = mkOption {
      default = false;
      type = types.bool;
      description = "enables home-related packages";
    };

    aidan.profile.gui = mkOption {
      default = false;
      type = types.bool;
      description = "enables all gui packages";
    };
  };

  config =
    mkMerge
    [
      (mkIf cfg.work {
        aidan.cli.kubectl.enable = mkDefault true;
      })
      (mkIf cfg.home {
        aidan.system.smb-share.enable = mkDefault true;
      })
      (mkIf cfg.gui {
        aidan.gui.xfce.enable = mkDefault true;
        aidan.gui.steam.enable = mkDefault true;
        aidan.gui.libratbag.enable = mkDefault true;
      })
    ];
}
