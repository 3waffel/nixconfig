{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config._mods.gitea;
  mail = config._mods.mailserver;
  gitea-agatheme = pkgs.fetchurl {
    url = "https://git.lain.faith/attachments/4c2c2237-1e67-458e-8acd-92a20d382777";
    sha256 = "sha256-uwtg6BAR5J28Ls3naQkJg7xBEfZPXVS5INH+bsVn4Uk=";
  };
  gitea-nord = pkgs.fetchurl {
    url = "https://gist.githubusercontent.com/3waffel/6d80f0670d41c51bfabfd9a95c237844/raw/1630f7d5d8f8c8a21f604e6665ad2062bc0a9abf/theme-nord.css";
    sha256 = "sha256-8yR5fhxet0majmvivxFs0/8NY0CchlkTBzLeIH6npLo=";
  };
in
  with lib; {
    options._mods.gitea = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
      port = mkOption {
        default = 8000;
      };
      enableCaddy = mkOption {
        type = types.bool;
        default = false;
      };
      vhost = mkOption {
        type = types.str;
        default = "git.kusako.de";
      };
    };

    config = mkIf cfg.enable {
      services.gitea = {
        enable = true;
        lfs.enable = true;
        database.type = "postgres";
        appName = "Yoshika Gitea";
        settings = {
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
          ui = {
            THEMES = "gitea,arc-green,agatheme,nord";
            DEFAULT_THEME = "nord";
          };
          session.COOKIE_SECURE = true;
          repository.ENABLE_PUSH_CREATE_USER = true;
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

      system.activationScripts.gitea-theme = let
        target_dir = "${config.services.gitea.stateDir}/custom/public/css";
      in
        lib.stringAfter ["var"] ''
          mkdir -p ${target_dir}
          ln -s ${gitea-agatheme} "${target_dir}/theme-agatheme.css"
          ln -s ${gitea-nord} "${target_dir}/theme-nord.css"
        '';

      services.caddy = mkIf cfg.enableCaddy {
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
