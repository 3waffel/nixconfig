{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config._mods.ustreamer;
in {
  imports = [
    ./ngrok.nix
  ];

  options._mods.ustreamer = {
    enable = mkEnableOption "Ustreamer service";
  };

  config = mkIf cfg.enable {
    systemd.services.ustreamer = mkService {
      ExecStart = "${pkgs.ustreamer}/bin/ustreamer -r 1920x1080 -s :: -p 8080";
      SupplementaryGroups = ["video"];
      unitConfig = {
        StartLimitIntervalSec = 0;
      };
      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        inherit ExecStart SupplementaryGroups;
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
