{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  lan = "enp1s0";
  wan = "enp2s0";
  vlan_list = [10 20 21 25 30 40];
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
      "net.ipv6.conf.${lan}/10.accept_ra" = 2; # Temp before go live
      "net.ipv6.conf.${lan}/10.autoconf" = 1; # Temp before go live
    };

    networking = {
      useDHCP = false;
      nameservers = ["192.168.30.250" "192.168.30.251" "fd00:30::250" "fd00:30::251"];

      # Enumerate VLANs from vlan_list
      vlans = builtins.listToAttrs (map (vlan:
        lib.nameValuePair "${"${lan}.${builtins.toString vlan}"}" {
          id = vlan;
          interface = "${lan}";
        })
      vlan_list);

      interfaces =
        builtins.listToAttrs (map (vlan:
          lib.nameValuePair "${"${lan}.${builtins.toString vlan}"}" {
            ipv4.addresses = [
              {
                address = "192.168.${builtins.toString vlan}.3";
                prefixLength = 24;
              }
            ];
            ipv6.addresses = [
              {
                address = "fd00:${builtins.toString vlan}::3";
                prefixLength = 64;
              }
            ];
          })
        vlan_list)
        // {
          ${wan}.useDHCP = true;
          ${lan}.useDHCP = false;

          "${lan}.10" = {
            # Temp before go live
            ipv4.routes = [
              {
                address = "0.0.0.0";
                prefixLength = 0;
                via = "192.168.10.1";
                options.scope = "global";
              }
            ];
          };
        };
    };

    system.stateVersion = "24.11";
  };
}
