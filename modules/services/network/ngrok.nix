{
  flake.modules.nixos.ngrok = {
    pkgs,
    lib,
    config,
    ...
  }: let
    logLevel = "debug";
    configFile = config.sops.templates."ngrok.yml".path or pkgs.emptyFile;
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

    sops = {
      secrets.ngrok-authtoken = {};
      templates."ngrok.yml".content = ''
        version: 3
        agent:
          authtoken: ${config.sops.placeholder.ngrok-authtoken}
        endpoints:
          - name: ssh
            upstream:
              url: 22
      '';
    };
  };
}
