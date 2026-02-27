let
  port = 8080;
in {
  flake.modules.nixos.ustreamer = {pkgs, ...}: {
    systemd.services.ustreamer = {
      unitConfig = {
        StartLimitIntervalSec = 0;
      };
      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        ExecStart = "${pkgs.ustreamer}/bin/ustreamer -r 1920x1080 -s :: -p ${toString port}";
        SupplementaryGroups = ["video"];
      };
      wantedBy = ["multi-user.target"];
    };
  };
}
