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
in
  with lib; {
    options._mods.gitea = {
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
          service = {
            DISABLE_REGISTRATION = true;
            DEFAULT_KEEP_EMAIL_PRIVATE = true;
            LANDING_PAGE = "explore";
          };
          ui = {
            THEMES = "gitea,arc-green,agatheme";
            DEFAULT_THEME = "agatheme";
          };
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

      system.activationScripts.gitea-theme = let
        target_dir = "${config.services.gitea.stateDir}/custom/public/css";
      in
        lib.stringAfter ["var"] ''
          mkdir -p ${target_dir}
          ln -s ${gitea-agatheme} "${target_dir}/theme-agatheme.css"
        '';

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
