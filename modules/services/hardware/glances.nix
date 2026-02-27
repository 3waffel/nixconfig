let
  port = 61208;
in {
  flake.modules.nixos.glances = {
    pkgs,
    lib,
    ...
  }: {
    systemd.services.glances = {
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      script = "${lib.getExe pkgs.glances} --webserver --bind 0.0.0.0 --port ${toString port}";
      serviceConfig = {
        Restart = "on-abort";
        RemainAfterExit = "yes";
      };
    };
    networking.firewall.allowedTCPPorts = [port];
  };
}
