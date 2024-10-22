{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services._ustreamer;
in
  with lib; {
    options.services._ustreamer = {
      enable = mkEnableOption "Ustreamer service";
      port = mkOption {
        type = types.port;
        default = 8080;
      };
    };

    config = mkIf cfg.enable {
      systemd.services.ustreamer = {
        unitConfig = {
          StartLimitIntervalSec = 0;
        };
        serviceConfig = {
          DynamicUser = true;
          Restart = "always";
          ExecStart = "${pkgs.ustreamer}/bin/ustreamer -r 1920x1080 -s :: -p ${toString cfg.port}";
          SupplementaryGroups = ["video"];
        };
        wantedBy = ["multi-user.target"];
      };
    };
  }
