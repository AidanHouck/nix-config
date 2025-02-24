{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.vars;
in {
  options = {
    aidan.vars.hostname = mkOption {
      type = types.str;
      default = "hostname";
    };
    aidan.vars.username = mkOption {
      type = types.str;
      default = "houck";
    };
  };
}
