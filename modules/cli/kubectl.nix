{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    aidan.modules.cli.kubectl.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = "enables kubectl";
    };
  };

  config = lib.mkIf config.aidan.modules.cli.kubectl.enable {
    environment.systemPackages = with pkgs; [
      kubectl
      kustomize
    ];

    sops.secrets."kubectl-config" = {
      owner = "${config.aidan.modules.system.users.username}";
      group = "users";
      mode = "0400";
      path = "/home/${config.aidan.modules.system.users.username}/.kube/config";
    };
  };
}
