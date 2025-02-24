{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.steam;
in {
  options = {
    aidan.gui.steam.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables steam";
    };
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Steam Remote Play
      dedicatedServer.openFirewall = true; # Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Steam Local Network Game Transfers
    };
  };
}
