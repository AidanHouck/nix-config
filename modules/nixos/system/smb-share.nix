{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.system.smb-share;
in {
  options = {
    aidan.system.smb-share.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables mounting LAN samba share";
    };
    # TODO expose more options like fqdn and path
  };

  config = mkIf cfg.enable {
    # From https://nixos.wiki/wiki/Samba#Samba_Client
    environment.systemPackages = with pkgs; [
      cifs-utils
    ];

    # Expose /run/secrets/smb-secrets for credentials
    sops.secrets = {
      smb-secrets.owner = "${config.aidan.vars.username}";
    };

    # Mount the share
    fileSystems."/mnt/zfs" = {
      device = "//pve.lan.aidanhouck.com/zfsshare/";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in ["${automount_opts},credentials=/run/secrets/smb-secrets,uid=1000,gid=100"];
    };
  };
}
