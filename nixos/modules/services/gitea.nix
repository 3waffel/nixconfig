{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.mods.gitea;
  mail = config.mods.mailserver;
in
  with lib; {
    options.mods.gitea = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      vhost = mkOption {
        type = types.str;
        default = "git.kusako.de";
      };
      port = mkOption {
        default = 8000;
      };
    };

    config = mkIf cfg.enable {
      services.gitea = {
        enable = true;
        lfs.enable = true;
        database.type = "postgres";
        appName = "Yoshika Gitea";
        httpPort = cfg.port;
        domain = "${cfg.vhost}";
        rootUrl = "https://${cfg.vhost}";
        settings = {
          service.DISABLE_REGISTRATION = true;
          session.COOKIE_SECURE = true;
        };
        # }
        # // mkIf mail.enable {
        #   mailerPasswordFile = config.sops.secrets.gitea-mail.path;
        #   settings.mailer = {
        #     ENABLED = true;
        #     FROM = "gitea@${mail.domain}";
        #     USER = "gitea@${mail.domain}";
        #     HOST = "${mail.domain}:${mail.port}";
        #   };
      };

      services.caddy = {
        enable = true;
        virtualHosts."${cfg.vhost}" = {
          extraConfig = ''
            reverse_proxy localhost:${toString cfg.port}
          '';
        };
      };

      # services.nginx = {
      #   enable = true;
      #   virtualHosts."${cfg.vhost}" = {
      #     forceSSL = true;
      #     enableACME = true;
      #     locations."/" = {
      #       proxyPass = "http://localhost:${toString cfg.port}";
      #     };
      #   };
      # };
    };
  }
