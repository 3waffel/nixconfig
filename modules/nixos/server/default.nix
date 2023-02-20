{
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [
    ./gitea.nix
    ./mailserver.nix
    ./minecraft.nix
    ./misskey.nix
    ./netdata.nix
    ./vscode-server.nix
  ];
}
