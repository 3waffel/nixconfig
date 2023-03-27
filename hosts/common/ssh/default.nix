{
  config,
  lib,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = config.services.openssh.ports;

  services.openssh = {
    enable = true;
    ports = [22];
    settings.PasswordAuthentication = false;
  };
}
