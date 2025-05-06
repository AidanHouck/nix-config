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

      # Docker Nodes
      Host docker-1
          HostName mveca-docker-01.mveca.org

      Host docker-2
          HostName mveca-docker-02.mveca.org

      Host docker-3
          HostName mveca-docker-03.mveca.org

      Host docker-4
          HostName mveca-docker-04.mveca.org

      Host docker-5
          HostName mveca-docker-05.mveca.org

      Host docker-6
          HostName mveca-docker-06.mveca.org

      Host docker-test
          HostName mveca-docker-test.mveca.org

      Host docker-pb
          HostName mesh-cp.mveca.org

      Host docker-*
          User houck.admin

      # Kubernetes Nodes
      Host kube-server-01
          HostName kube-server-01.mveca.org

      Host kube-server-02
          HostName kube-server-02.mveca.org

      Host kube-server-03
          HostName kube-server-03.mveca.org

      Host kube-agent-01
          HostName kube-agent-01.mveca.org

      Host kube-agent-02
          HostName kube-agent-02.mveca.org

      Host kube-agent-03
          HostName kube-agent-03.mveca.org

      Host kube-*
          User houck.admin

      # Misc
      Host secure-note
          HostName secure-note.mveca.org
          User houck.admin
    '';

    system.stateVersion = "24.05";
  };
}
