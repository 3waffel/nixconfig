{
  config,
  lib,
  pkgs,
  vscode-server,
  ...
}: let
  cfg = config._mods.vscode-server;
in
  with lib; {
    imports = [
      vscode-server.nixosModule
    ];

    options._mods.vscode-server = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };

    config = mkIf cfg.enable {
      services.vscode-server.enable = true;
    };
  }
