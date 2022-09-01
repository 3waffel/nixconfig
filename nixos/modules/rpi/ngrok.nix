{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mods.ngrok;
in
  with lib; {
    options.mods.ngrok = {
      enable = mkEnableOption "Ngrok tls service";

      logLevel = mkOption {
        type = types.str;
        default = "debug";
        defaultText = literalExample "debug";
        description = "The log level to use.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.ngrok;
        defaultText = literalExample "pkgs.ngrok";
        description = "Which ngrok package to install.";
      };

      configFile = mkOption {
        type = types.str;
        default = "";
      };
    };

    config = mkIf cfg.enable {
      systemd.services.ngrok = {
        unitConfig = {
          Description = "Ngrok services";
          After = "network.target";
        };

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/ngrok start --log stdout --log-level ${cfg.logLevel} --all --config ${cfg.configFile}";
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = "read-only";
          ExecReload = "/bin/kill -HUP $MAINPID";
          KillMode = "process";
          IgnoreSIGPIPE = "true";
          Restart = "always";
          RestartSec = "3";
          Type = "simple";
        };

        wantedBy = ["multi-user.target"];
      };
    };
  }
