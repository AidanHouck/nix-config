{ pkgs, lib, config, ... }:
{
  options = {
    cli.git.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables git";
    };
  };

  config = lib.mkIf config.cli.git.enable {
    environment.systemPackages = with pkgs; [
      git 
    ];
  };
}
