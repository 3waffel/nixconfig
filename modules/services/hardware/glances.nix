{
  flake.modules.nixos.glances = {
    services.glances = {
      enable = true;
      port = 61208;
      openFirewall = true;
      extraArgs = ["--webserver" "-B0.0.0.0"];
    };
  };
}
