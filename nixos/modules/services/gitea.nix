{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom_modules.gitea;
  mail = config.custom_modules.mailserver;
in {
  options.custom_modules.gitea = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    domain = lib.mkOption {
      type = lib.types.str;
      default = "yoshika.mooo.com";
    };
  };
  config = lib.mkIf cfg.enable {
    services.gitea = {
      enable = true;
      lfs.enable = true;
      cookieSecure = true;
      disableRegistration = true;
      database.type = "postgres";
      appName = "Yoshika Gitea";
      httpPort = 8000;
      domain = "${cfg.domain}";
      rootUrl = "https://${cfg.domain}";

      mailerPasswordFile = lib.mkIf mail.enable config.sops.secrets.gitea-mail.path;
      settings.mailer = lib.mkIf mail.enable {
        ENABLED = true;
        FROM = "gitea@${mail.domain}";
        USER = "gitea@${mail.domain}";
        HOST = "${mail.domain}:${mail.port}";
      };
    };

    services.caddy = {
      enable = true;
      extraConfig = ''
        ${cfg.domain} {
          reverse_proxy localhost:8000
        }
      '';
    };
  };
}
