{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.aidan.cli.bitwarden-cli;
in {
  options = {
    aidan.cli.bitwarden-cli.enable = mkOption {
      default = true;
      type = types.bool;
      description = "enables bitwarden-cli";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bitwarden-cli
    ];

    sops.secrets = {
      bitwarden-client_id.owner = "${config.aidan.vars.username}";
      bitwarden-client_secret.owner = "${config.aidan.vars.username}";
      bitwarden-master_pass.owner = "${config.aidan.vars.username}";
    };

    # https://github.com/bitwarden/clients/issues/6689#issuecomment-1787609205
    environment.variables.NODE_OPTIONS = "--no-deprecation";

    # https://bitwarden.com/help/personal-api-key/
    programs.bash.shellInit = ''
      export BW_CLIENTID="$(cat ${config.sops.secrets.bitwarden-client_id.path})"
      export BW_CLIENTSECRET="$(cat ${config.sops.secrets.bitwarden-client_secret.path})"
      export BW_MASTER_PASS="$(cat ${config.sops.secrets.bitwarden-master_pass.path})"
    '';
  };
}
