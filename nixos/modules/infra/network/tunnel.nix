{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config._mods.tunnel;
in
  with lib; {
    options._mods.tunnel = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };

    config = mkIf cfg.enable {
      users.users.cloudflared = {
        group = "cloudflared";
        isSystemUser = true;
      };
      users.groups.cloudflared = {};
      sops.secrets.cloudflared-tunnel-token = {};
      systemd.services.cloudflared-tunnel = {
        description = "Cloudflare Tunnel";
        after = ["network-online.target" "systemd-resolved.service"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          ExecStart = ''
            token="$(cat ${config.sops.secrets.cloudflared-tunnel-token.path})"
            ${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token=<token>
          '';
          Restart = "always";
          RestartSec = "5s";
          User = "cloudflared";
          Group = "cloudflared";
        };
      };
    };
  }
