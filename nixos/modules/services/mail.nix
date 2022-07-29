{
  config,
  lib,
  simple-mailserver,
  ...
}: let
  cfg = config.custom_modules.mailserver;
in {
  imports = [
    simple-mailserver.nixosModule
  ];

  options.custom_modules.mailserver = {
    enable = lib.mkOption {
      description = "";
      type = lib.types.bool;
      default = false;
    };
    domain = lib.mkOption {
      default = "yurako.mooo.com";
    };
    port = lib.mkOption {
      default = "587";
    };
  };

  config = lib.mkIf cfg.enable {
    security.acme = {
      acceptTerms = true;
      email = "";
    };
    mailserver = {
      enable = true;
      fqdn = "mail.${cfg.domain}";
      domains = ["${cfg.domain}"];
      loginAccounts = {
        "me@${cfg.domain}" = {
          hashedPasswordFile = config.sops.secrets.hashed-email-password.path;
          aliases = ["postmaster@${cfg.domain}"];
        };
        "gitea@${cfg.domain}" = {
        };
      };
    };
  };
}
