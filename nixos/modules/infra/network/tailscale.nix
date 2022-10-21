{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config._mods.tailscale;
in
  with lib; {
    options._mods.tailscale = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };

    config = mkIf cfg.enable {
      services.tailscale.enable = true;
      environment.systemPackages = [pkgs.tailscale];
      sops.secrets.tailscale-authkey = {};
      systemd.services.tailscale-autoconnect = {
        description = "Automatic connection to Tailscale";
        after = ["network-pre.target" "tailscale.service"];
        wants = ["network-pre.target" "tailscale.service"];
        wantedBy = ["multi-user.target"];
        serviceConfig.Type = "oneshot";
        script = with pkgs; ''
          # wait for tailscaled to settle
          sleep 2

          # check if we are already authenticated to tailscale
          status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
          fi

          # otherwise authenticate with tailscale
          tskey="$(cat ${config.sops.secrets.tailscale-authkey.path})"
          ${tailscale}/bin/tailscale up -authkey $tskey
        '';
      };
      networking.firewall = {
        trustedInterfaces = ["tailscale0"];
        allowedUDPPorts = [config.services.tailscale.port];
        checkReversePath = "loose";
      };
    };
  }
