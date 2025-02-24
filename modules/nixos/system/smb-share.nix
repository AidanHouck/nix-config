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

    aidan.system.smb-share.server = mkOption {
      default = "pve.lan.aidanhouck.com";
      type = types.str;
      description = "IP or FQDN of the server to connect to";
    };

    aidan.system.smb-share.share = mkOption {
      default = "zfsshare";
      type = types.str;
      description = "Name of the share to mount";
    };

    aidan.system.smb-share.mount = mkOption {
      default = "/mnt/zfs";
      type = types.str;
      description = "File path to mount the share to";
    };
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
    fileSystems."${cfg.mount}" = {
      device = "//${cfg.server}/${cfg.share}/";
      fsType = "cifs";
      options = let
        automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in ["${automount_opts},credentials=/run/secrets/smb-secrets,uid=1000,gid=100"];
    };
  };
}
