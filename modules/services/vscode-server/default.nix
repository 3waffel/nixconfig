{inputs, ...}: {
  flake.modules.nixos.vscode-server = {
    imports = [
      inputs.vscode-server.nixosModule
    ];

    services.vscode-server.enable = true;
  };
}
