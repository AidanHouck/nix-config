{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    cli.bitwarden-cli.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables bitwarden-cli";
    };
  };

  config = lib.mkIf config.cli.bitwarden-cli.enable {
    environment.systemPackages = with pkgs; [
      bitwarden-cli
    ];

    sops.secrets = {
      bitwarden-client_id.owner = "${config.aidan.modules.system.users.username}";
      bitwarden-client_secret.owner = "${config.aidan.modules.system.users.username}";
      bitwarden-master_pass.owner = "${config.aidan.modules.system.users.username}";
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
