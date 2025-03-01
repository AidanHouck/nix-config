{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./vim
    ./fastfetch

    ./git.nix
    ./ffmpeg.nix
    ./weechat.nix
  ];
}
