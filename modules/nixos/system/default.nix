{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./ssh.nix
    ./sudo.nix
    ./users.nix
    ./smb-share.nix
  ];
}
