{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    gui.steam.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables steam";
    };
  };

  config = lib.mkIf config.gui.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Steam Remote Play
      dedicatedServer.openFirewall = true; # Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Steam Local Network Game Transfers
    };
  };
}
