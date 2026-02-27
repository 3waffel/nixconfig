{
  flake.modules.nixos.tailscale = {
    config,
    pkgs,
    lib,
    ...
  }: let
    withProxy = lib.mkDefault ["https_proxy=http://127.0.0.1:7890"];
    tokenFile = config.sops.secrets.tailscale-authkey.path or "";
  in {
    services.tailscale.enable = true;
    environment.systemPackages = [pkgs.tailscale];
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
        status="$(${lib.getExe tailscale} status -json | ${lib.getExe jq} -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # otherwise authenticate with tailscale
        tskey="$(cat ${tokenFile})"
        ${lib.getExe tailscale} up -authkey $tskey
      '';
    };
    networking.firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [config.services.tailscale.port];
      checkReversePath = "loose";
    };
    systemd.services.tailscaled = {
      serviceConfig.Environment = withProxy;
    };
  };
}
