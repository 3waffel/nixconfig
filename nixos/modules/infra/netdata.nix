{
  config,
  lib,
  ...
}: let
  cfg = config._mods.netdata;
in
  with lib; {
    options._mods.netdata = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      vhost = mkOption {
        type = types.str;
        default = "netdata.kusako.de";
      };
      port = mkOption {
        default = 19999;
      };
    };

    config = mkIf cfg.enable {
      services.netdata = {
        enable = true;
        config = {
          global = {
            "default port" = toString cfg.port;
            "bind to" = "127.0.0.1";
          };
        };
      };
      networking.firewall.allowedTCPPorts = [cfg.port];
    };
  }
