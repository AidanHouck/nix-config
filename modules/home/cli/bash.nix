{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    home.cli.bash.enable = lib.mkOption {
      default = true;
      type = lib.types.bool;
      description = "enables bash home-manager module";
    };
  };

  config = lib.mkIf config.home.cli.bash.enable {
    #programs.bash = {
    #  enable = true;
    #};

    home.file = {
      ".bashrc" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/nix-config/modules/home/cli/.bashrc";
      };
      ".bash_aliases" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/src/nix-config/modules/home/cli/.bash_aliases";
      };
    };
  };
}
