{
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [
    ./gitea.nix
    ./mailserver.nix
    ./misskey.nix
    ./network/tailscale.nix
  ];
}
