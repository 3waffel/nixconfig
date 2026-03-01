{
  flake.modules.nixos.tailscale = {
    config,
    lib,
    ...
  }: let
    enableProxy = false;
    authKeyFile = config.sops.secrets.tailscale-authkey.path or null;
  in {
    services.tailscale = {
      inherit authKeyFile;
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "both";
    };

    systemd.services.tailscaled = lib.mkIf enableProxy {
      # TODO
      serviceConfig.Environment = [];
    };
  };
}
