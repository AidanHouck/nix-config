{ pkgs, lib, config, ... }:
{
  options = {
    system.wlan.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables wlan connection";
    };
  };

  config = lib.mkIf config.system.wlan.enable {
    # Setup wireless using SSID/PSK from SOPS file
    networking = {
      hostName = config.variables.hostname;
      wireless = {
        enable = true;
        environmentFile = config.sops.secrets."wireless.env".path;
        networks = {
          "@home_uuid@" = {
            psk = "@home_psk@";
          };
        };
        interfaces = [ config.variables.interface ];
      };
    };
  };
}
