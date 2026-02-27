{
  flake.modules.nixos.ngrok = {
    pkgs,
    lib,
    config,
    ...
  }: let
    logLevel = "debug";
    configFile = config.sops.secrets.ngrok-config.path or "";
  in {
    systemd.services.ngrok = {
      unitConfig = {
        Description = "Ngrok services";
        After = "network.target";
      };

      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.ngrok} start --log stdout --log-level ${logLevel} --all --config ${configFile}";
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
