{
  config,
  lib,
  simple-mailserver,
  ...
}: let
  cfg = config.mods.mailserver;
in
  with lib; {
    imports = [
      simple-mailserver.nixosModule
    ];

    options.mods.mailserver = {
      enable = mkOption {
        description = "";
        type = types.bool;
        default = false;
      };
      domain = mkOption {
        default = "kusako.de";
      };
    };

    config = lib.mkIf cfg.enable {
      security.acme = {
        acceptTerms = true;
        defaults.email = "me@${cfg.domain}";
      };
      sops.secrets.hashed-email-password = {};
      mailserver = {
        enable = true;
        fqdn = "mail.${cfg.domain}";
        domains = ["${cfg.domain}"];
        loginAccounts = {
          "me@${cfg.domain}" = {
            # Generate a hashed key
            # `nix-shell -p apacheHttpd`
            # `htpasswd -nbB "" "yourpassword" | cut -d: -f2`
            hashedPasswordFile = config.sops.secrets.hashed-email-password.path;
            aliases = ["postmaster@${cfg.domain}"];
          };
          # }
          # // {
          #   "gitea@${cfg.domain}" = {
          #     hashedPasswordFile = config.sops.secrets.gitea-mail.path;
          #     aliases = [];
          #     sendOnly = true;
          #   };
        };
        certificateScheme = 3;
      };
    };
  }
