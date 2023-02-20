{
  config,
  lib,
  ...
}: let
  cfg = config._mods.dendrite;
in
  with lib; {
    options._mods.dendrite = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      port = mkOption {
        default = 8043;
      };
      enableCaddy = mkOption {
        type = types.bool;
        default = false;
      };
      vhost = mkOption {
        type = types.str;
        default = "mx.kusako.de";
      };
    };

    config = mkIf cfg.enable {
      sops.secrets.matrix-server-key = {};
      services.dendrite = {
        enable = true;
        httpPort = cfg.port;
        settings = {
          server_name = "";
          private_key = "";
          trusted_third_party_id_servers = [
            "matrix.org"
            "vector.im"
          ];
          metrics.enable = true;
        };
        logging = [
          {
            type = "std";
            level = "warn";
          }
        ];
      };

      services.caddy = mkIf cfg.enableCaddy {
        enable = true;
        virtualHosts."${cfg.vhost}" = {
          extraConfig = ''
            reverse_proxy localhost:${toString cfg.port}
          '';
        };
      };
    };
  }
