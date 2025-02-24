{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.network.wlan;
in {
  options = {
    aidan.network.wlan.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables wlan connection";
    };

    aidan.network.wlan.interface = mkOption {
      default = "wlan0";
      type = types.str;
      description = "wireless network adapter interface name";
    };
  };

  config = mkIf cfg.enable {
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
        interfaces = [cfg.interface];
      };
    };
  };
}
