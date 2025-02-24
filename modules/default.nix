{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption mkMerge mkDefault types;
  cfg = config.aidan;
in {
  imports = [
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
      (mkIf cfg.profile.work {
        aidan.cli.kubectl.enable = mkDefault true;
      })
      # TODO: Remove this and populate with real profiles
      (mkIf cfg.profile.home {
        aidan.cli.kubectl.enable = mkDefault true;
      })
    ];
}
