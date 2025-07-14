{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  hostname = "wsl-work";
in {
  # Imports
  imports = [
    ../common.nix
  ];

  config = {
    aidan.vars.hostname = hostname;

    aidan.profile.work = true;

    fileSystems."/mnt/o" = {
      device = "O:";
      fsType = "drvfs";
      options = [
        "metadata"
        "rw"
        "noatime"
        "uid=1001"
        "gid=100"
        "umask=22"
        "fmask=11"
      ];
    };

    programs.ssh.extraConfig = ''
      # Allow unknown fingerprints
      StrictHostKeyChecking accept-new

      # Always try RSA pubkey because old Cisco switches
      PubkeyAcceptedKeyTypes +ssh-rsa

      # Raise default auth retries
      NumberOfPasswordPrompts 5

      Host secure-note
          HostName secure-note.mveca.org
          User houck.admin
    '';

    system.stateVersion = "24.05";
  };
}
