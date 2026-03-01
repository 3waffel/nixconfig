{
  flake.modules.nixos.ustreamer = {pkgs, ...}: {
    services.ustreamer = {
      enable = true;
      listenAddress = "0.0.0.0:8080";
    };
  };
}
