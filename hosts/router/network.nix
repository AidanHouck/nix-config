{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  wan = "enp1s0";
  lan = "enp2s0";
in {
  config = {
    environment.systemPackages = with pkgs; [
      # ??
    ];

    boot.kernel.sysctl = {
      # Allow packet forwarding
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;

      # IPv6 autoconfiguration on WAN only
      "net.ipv6.conf.all.accept_ra" = 0;
      "net.ipv6.conf.all.autoconf" = 0;
      "net.ipv6.conf.all.use_tempaddr" = 0;
      "net.ipv6.conf.${wan}.accept_ra" = 2;
      "net.ipv6.conf.${wan}.autoconf" = 1;
    };

    networking = {
      useDHCP = false;
      nameservers = [ "192.168.30.250" "192.168.30.251" "fd00:30::250" "fd00:30::251" ];
      vlans = {
        "${lan}.10" = {
          id = 10;
          interface = "${lan}";
        };

        "${lan}.20" = {
          id = 20;
          interface = "${lan}";
        };
      };

      interfaces = {
        ${wan}.useDHCP = true;

        "${lan}.10" = {
          ipv4.addresses = [{
            address = "10.10.10.1";
            prefixLength = 24;
          }];
        };

        "${lan}.20" = {
          ipv4.addresses = [{
            address = "10.10.20.1";
            prefixLength = 24;
          }];
        };
      };
    };


    system.stateVersion = "24.11";
  };
}
