{ config, pkgs, lib, ... }:

let
  foo = "bar";
in {

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Common software
  environment.systemPackages = with pkgs; [
    git # Must init git first for Flakes dependency cloning
    vim
    wget
  ];
  environment.variables.EDITOR = "vim";
  
  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
  
  # Sudo
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ];
    }
  ];
}