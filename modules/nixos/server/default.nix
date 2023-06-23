{
  pkgs,
  lib,
  ...
}:
with lib; {
  imports = [
    ./cockpit.nix
    ./gitea.nix
    ./mailserver.nix
    ./minecraft.nix
    ./misskey.nix
    ./netdata.nix
    ./vscode-server.nix
  ];
}
