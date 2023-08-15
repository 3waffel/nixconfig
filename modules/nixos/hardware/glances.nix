{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config._mods.glances;
in
  with lib; {
    options._mods.glances = {
      enable = mkEnableOption "Glances service";
      port = mkOption {
        type = types.port;
        default = 61208;
      };
    };
    config = mkIf cfg.enable {
      systemd.services.glances = {
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        script = "${pkgs.glances}/bin/glances --webserver --bind 0.0.0.0 --port ${toString cfg.port}";
        serviceConfig = {
          Restart = "on-abort";
          RemainAfterExit = "yes";
        };
      };
      networking.firewall.allowedTCPPorts = [cfg.port];
    };
  }
