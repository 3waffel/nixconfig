{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config._mods.forgejo;
in
  with lib; {
    options._mods.forgejo = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      port = mkOption {
        default = 8000;
      };
      vhost = mkOption {
        type = types.str;
        default = "forge.kusako.de";
      };
    };

    config = mkIf cfg.enable {
      services.forgejo = {
        enable = true;
        lfs.enable = true;
        database.type = "postgres";
        settings = {
          DEFAULT.APP_NAME = "3waffel's Forgejo";
          server = {
            ROOT_URL = "https://${cfg.vhost}";
            HTTP_PORT = cfg.port;
            DOMAIN = "${cfg.vhost}";
          };
          service = {
            DISABLE_REGISTRATION = true;
            DEFAULT_KEEP_EMAIL_PRIVATE = true;
            LANDING_PAGE = "explore";
          };
          session.COOKIE_SECURE = true;
          repository.ENABLE_PUSH_CREATE_USER = true;
        };
      };
    };
  }
