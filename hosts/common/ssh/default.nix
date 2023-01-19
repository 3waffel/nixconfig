{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = config.services.openssh.ports;

  services.openssh = {
    enable = true;
    passwordAuthentication = false;
    ports = [22];
  };
}
