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
    wsl.wslConf.network.hostname = hostname;

    # Host specific packages
    environment.systemPackages = with pkgs; [
      # TODO
    ];

    programs.ssh.extraConfig = ''
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
    '';

    system.stateVersion = "24.05";
  };
}
