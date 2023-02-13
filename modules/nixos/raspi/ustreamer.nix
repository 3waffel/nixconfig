{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config._mods.ustreamer;
in
  with lib; {
    options._mods.ustreamer = {
      enable = mkEnableOption "Ustreamer service";
    };

    config = mkIf cfg.enable {
      systemd.services.ustreamer = {
        unitConfig = {
          StartLimitIntervalSec = 0;
        };
        serviceConfig = {
          DynamicUser = true;
          Restart = "always";
          ExecStart = "${pkgs.ustreamer}/bin/ustreamer -r 1920x1080 -s :: -p 8080";
          SupplementaryGroups = ["video"];
        };
        wantedBy = ["multi-user.target"];
      };
    };
  }
