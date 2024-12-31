{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    network.hostname.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables setting the system hostname";
    };
  };

  config = lib.mkIf config.network.hostname.enable {
    networking.hostName = config.aidan.vars.hostname;
  };
}
