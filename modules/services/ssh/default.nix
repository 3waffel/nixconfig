{
  flake.modules.nixos.ssh = {config, ...}: {
    networking.firewall.allowedTCPPorts = config.services.openssh.ports;

    services.openssh = {
      enable = true;
      ports = [22];
      settings.PasswordAuthentication = false;
    };
  };
}
