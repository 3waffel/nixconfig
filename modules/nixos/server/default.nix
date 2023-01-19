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
    ./netdata.nix
    ./vscode-server.nix
  ];
}
