{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  lan = "untagged0";
  wan = "wan0";

  createVlanNetdev = name: (vlan: {
    netdevConfig = {
      Name = name;
      Kind = "vlan";
    };
    vlanConfig.Id = vlan;
  });

  createVlanNetwork = name: (vlan: {
    matchConfig.Name = name;
    address = [
      "192.168.${toString vlan}.3/24"
      "fd00:${toString vlan}::3/64"
      "fe80::1/64"
    ];
    networkConfig = {
      DHCPPrefixDelegation = true;
      DHCPServer = true;
      IPv6AcceptRA = false;
    };
    dhcpPrefixDelegationConfig = {
      Token = "::1";
      # SubnetID = TODO?
    };
    # DHCP TODO?
  });
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
      useNetworkd = true;
      useDHCP = false;
      nameservers = ["192.168.30.250" "192.168.30.251" "fd00:30::250" "fd00:30::251"];
      nat.enable = false;
      firewall.enable = false;
    };

    systemd.network = {
      enable = true;

      config.networkConfig = {
        SpeedMeter = true;
      };

      # Physical interfaces
      links."0-${wan}" = {
        matchConfig = {
          Type = "ether";
          MACAddress = "00:0a:cd:00:07:3a";
        };
        linkConfig = {
          Name = wan;
        };
      };
      networks."0-${wan}" = {
        matchConfig.Name = wan;
        networkConfig.DHCP = "yes";
        dhcpV4Config = {
          UseDNS = false;
          UseDomains = false;
          SendRelease = false;
        };
        dhcpV6Config = {
          PrefixDelegationHint = "::/56";
          UseDNS = false;
        };
        ipv6AcceptRAConfig = {
          UseDNS = false;
          UseDomains = false;
        };
      };

      links."1-${lan}" = {
        matchConfig = {
          Type = "ether";
          MACAddress = "34:73:5a:f1:b7:e1";
        };
        linkConfig = {
          Name = lan;
        };
      };
      networks."1-${lan}" = {
        matchConfig.Name = lan;
        vlan = [
          "lan0"
          "privSSID0"
          "guestSSID0"
          "colo0"
          "static0"
          "eth0"
        ];
      };

      # Create all VLANs
      # Commented out for default route until deployment
      #netdevs."10-lan0" = createVlanNetdev "lan0" 10;
      #networks."10-lan0" = createVlanNetwork "lan0" 10;
      netdevs."10-lan0" = {
        netdevConfig = {
          Name = "lan0";
          Kind = "vlan";
        };
        vlanConfig.Id = 10;
      };
      networks."10-lan0" = {
        matchConfig.Name = "lan0";
        address = [
          "192.168.10.3/24"
          "fd00:10::3/64"
          "fe80::1/64"
        ];
        networkConfig = {
          DefaultRouteOnDevice = true;
          DHCPPrefixDelegation = true;
          DHCPServer = true;
          IPv6AcceptRA = false;
        };
        dhcpPrefixDelegationConfig = {
          Token = "::1";
        };
      };

      netdevs."20-privSSID0" = createVlanNetdev "privSSID0" 20;
      networks."20-privSSID0" = createVlanNetwork "privSSID0" 20;

      netdevs."21-guestSSID0" = createVlanNetdev "guestSSID0" 21;
      networks."21-guestSSID0" = createVlanNetwork "guestSSID0" 21;

      netdevs."25-colo0" = createVlanNetdev "colo0" 25;
      networks."25-colo0" = createVlanNetwork "colo0" 25;

      netdevs."30-static0" = createVlanNetdev "static0" 30;
      networks."30-static0" = createVlanNetwork "static0" 30;

      netdevs."40-eth0" = createVlanNetdev "eth0" 40;
      networks."40-eth0" = createVlanNetwork "eth0" 40;
    };

    system.stateVersion = "24.11";
  };
}
