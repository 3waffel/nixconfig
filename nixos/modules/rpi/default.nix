{
  config,
  pkgs,
  lib,
  ...
}: let
  mkService = {
    ExecStart,
    SupplementaryGroups ? [],
  }: {
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
in {
  imports = [
    ./ngrok.nix
    ./srun.nix
  ];
  # systemd.services.powerd = mkService {
  #   ExecStart = "${(pkgs.python3.withPackages (ps: with ps; [libgpiod flask]))}/bin/python ${./powerd.py}";
  # };

  systemd.services.ustreamer = mkService {
    ExecStart = "${pkgs.ustreamer}/bin/ustreamer -r 1920x1080 -s :: -p 8080";
    SupplementaryGroups = ["video"];
  };

  sops.secrets.ngrok-config = {};
  mods.ngrok = {
    enable = true;
    configFile = config.sops.secrets.ngrok-config.path;
  };
}
