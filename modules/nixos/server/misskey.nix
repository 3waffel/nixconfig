{
  config,
  lib,
  misskey,
  ...
}: let
  cfg = config._mods.misskey;
in
  with lib; {
    imports = [misskey.nixosModule];
    options._mods.misskey = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      vhost = mkOption {
        default = "mk.kusako.de";
      };
      port = mkOption {
        default = 3000;
      };
    };

    config = mkIf cfg.enable {
      services.misskey = {
        enable = true;
        settings = {
          url = "https://${cfg.vhost}";
          port = cfg.port;
          redis.port = config.services.redis.servers.misskey.port;
        };
        redis.createLocally = false;
      };
      services.postgresql = {
        enable = true;
        ensureDatabases = ["misskey"];
        ensureUsers = [
          {
            name = "misskey";
            ensurePermissions."DATABASE misskey" = "ALL PRIVILEGES";
          }
        ];
      };
      services.redis.servers.misskey = {
        enable = true;
        port = 16434;
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
