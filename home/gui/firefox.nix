{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    aidan.home.gui.firefox.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables the firefox browser";
    };
  };

  config = lib.mkIf config.aidan.home.gui.firefox.enable {
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
