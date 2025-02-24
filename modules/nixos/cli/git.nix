{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.cli.git;
in {
  options = {
    aidan.cli.git.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables git";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      git
    ];
  };
}
