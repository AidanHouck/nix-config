{ pkgs, lib, config, ... }:
{
  options = {
    wlan.enable = lib.mkEnableOption "enables wlan";
  };

  config = lib.mkIf config.wlan.enable {
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
