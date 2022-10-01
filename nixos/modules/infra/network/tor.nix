{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config._mods.tor;
in
  with lib; {
    options._mods.tor = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      port = mkOption {
        default = 8080;
      };
    };

    config = mkIf cfg.enable {
      services.tor = {
        enable = true;
        enableGeoIP = false;
        relay.onionServices = {
          defaultService = {
            version = 3;
            map = [
              {
                port = 80;
                target = {
                  addr = "[::1]";
                  port = cfg.port;
                };
              }
            ];
          };
        };
        settings = {
          ClientUseIPv4 = false;
          ClientUseIPv6 = true;
          ClientPreferIPv6ORPort = true;
        };
      };
    };
  }
