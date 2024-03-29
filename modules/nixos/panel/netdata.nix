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
      port = mkOption {
        default = 19999;
      };
      vhost = mkOption {
        type = types.str;
        default = "netdata.kusako.de";
      };
    };

    config = mkIf cfg.enable {
      services.netdata = {
        enable = true;
        config = {
          global = {
            "default port" = toString cfg.port;
            "bind to" = "*";
          };
        };
      };
      networking.firewall.allowedTCPPorts = [cfg.port];
    };
  }
