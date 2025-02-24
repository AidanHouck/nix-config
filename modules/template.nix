# TODO: Update corresponding `default.nix` include list
# TODO: If needed, update respective profiles
{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  # TODO: ^H CATEGORY && ^H MODULE
  cfg = config.aidan.CATEGORY.MODULE;
in {
  options = {
    aidan.CATEGORY.MODULE.enable = mkOption {
      default = false; # TODO: true or false by default?
      type = types.bool;
      description = "foobar"; #TODO: fill out description
    };
  };

  config = mkIf cfg.enable {
    # TODO: Fill this out
  };
}
