{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    aidan.modules.network.wlan.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables wlan connection";
    };
  };

  config = lib.mkIf config.aidan.modules.network.wlan.enable {
    # Setup wireless using SSID/PSK from SOPS file
    sops.secrets."wpa_supplicant.conf" = {
      owner = "root";
      group = "root";
      mode = "0400";
      path = "/etc/wpa_supplicant.conf";
    };

    networking = {
      wireless = {
        enable = true;
        allowAuxiliaryImperativeNetworks = true; # Read /etc/wpa_supplicant.conf
        interfaces = [config.aidan.vars.interface];
      };
    };
  };
}
