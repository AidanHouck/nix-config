{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.cli.kubectl;
in {
  options = {
    aidan.cli.kubectl.enable = mkOption {
      default = false;
      type = types.bool;
      description = "enables kubectl";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      kubectl
      kustomize
      kompose
    ];

    sops.secrets."kubectl-config" = {
      owner = "${config.aidan.modules.system.users.username}";
      group = "users";
      mode = "0400";
      path = "/home/${config.aidan.modules.system.users.username}/.kube/config";
    };
  };
}
