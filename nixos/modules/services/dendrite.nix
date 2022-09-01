{
  config,
  lib,
  ...
}: let
  cfg = config.mods.dendrite;
in
  with lib; {
    options.mods.dendrite = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      vhost = mkOption {
        type = types.str;
        default = "mx.kusako.de";
      };
      port = mkOption {
        default = 8043;
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

      services.caddy = {
        enable = true;
        virtualHosts."${cfg.vhost}" = {
          extraConfig = ''
            reverse_proxy localhost:${toString cfg.port}
          '';
        };
      };
    };
  }
