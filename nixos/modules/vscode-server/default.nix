{
  config,
  lib,
  pkgs,
  vscode-server,
  ...
}: {
  imports = [
    vscode-server.nixosModule
  ];
  services.vscode-server.enable = true;
}
