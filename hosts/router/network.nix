{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  foo = "bar";
in {
  config = {
    environment.systemPackages = with pkgs; [
      # ??
    ];

    boot.kernel.sysctl = {
      # Allow packet forwarding
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = true;

      # IPv6 autoconfiguration
      # TODO: change to WAN?
      "net.ipv6.conf.all.accept_ra" = 2;
      "net.ipv6.conf.all.autoconf" = 1;
    };

    system.stateVersion = "24.11";
  };
}
