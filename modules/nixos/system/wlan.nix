{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    system.wlan.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables wlan connection";
    };
  };

  config = lib.mkIf config.system.wlan.enable {
    # Setup wireless using SSID/PSK from SOPS file
    sops.secrets."wpa_supplicant.conf" = {
      owner = "root";
      group = "root";
      mode = "0400";
      path = "/etc/wpa_supplicant.conf";
    };

    networking = {
      hostName = config.variables.hostname;
      wireless = {
        enable = true;
        allowAuxiliaryImperativeNetworks = true; # Read /etc/wpa_supplicant.conf
        interfaces = [config.variables.interface];
      };
    };
  };
}
