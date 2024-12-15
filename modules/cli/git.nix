{ pkgs, lib, config, ... }:
{
  options = {
    cli.git.enable = lib.mkEnableOption {
      default = true;
      description = "enables git";
    };
  };

  config = lib.mkIf config.cli.git.enable {
    environment.systemPackages = with pkgs; [
      git 
    ];
  };
}
