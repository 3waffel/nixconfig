{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config._mods.caddy;
in
  with lib; {
    options._mods.caddy = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      tsVhost = mkOption {
        type = types.str;
        default = "raspi.fish-mahi.ts.net";
      };
      httpPort = mkOption {
        type = types.port;
        default = 8880;
      };
      httpsPort = mkOption {
        type = types.port;
        default = 4443;
      };
    };

    config = mkIf cfg.enable {
      services.caddy = {
        enable = true;
        globalConfig = ''
          http_port ${toString cfg.httpPort}
          https_port ${toString cfg.httpsPort}
          auto_https off
        '';
      };
    };
  }
