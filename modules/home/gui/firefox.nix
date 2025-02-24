{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.gui.firefox;
in {
  options = {
    aidan.gui.firefox.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables the firefox browser";
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          # TODO: Possibly setup mozilla account
          id = 0;
          name = "default";
          isDefault = true;
          # TODO: Setup options, search engine, etc.
          # search = { };
          #extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          #  ublock-origin
          #  bitwarden
          #];
        };
      };
    };
  };
}
